require 'spec_helper'

describe IncomingEventsController do
	render_views

	context 'as html format' do
	  before do
	  	controller.stub(:logged_in?).and_return(true)
	  end

		describe 'GET index' do
			it "renders all incoming events" do
				incoming_event = FactoryGirl.create(:incoming_event)
				get :index
				response.should be_success
				response.should render_template 'index'
			end
		end

		describe 'GET show' do
			it 'renders a single incoming event' do
				incoming_event = FactoryGirl.create(:incoming_event)
				get :show, id: incoming_event.id
				response.should be_success
				response.should render_template 'show'
				assigns(:incoming_event).should eql incoming_event
			end
		end

		describe 'GET new' do
			it 'renders the new form' do
				get :new
				response.should be_success
				response.should render_template 'new'
				response.should render_template '_form'
				assigns(:incoming_event).should_not be_nil
			end
		end

		describe 'POST create' do
			context 'with invalid data' do
				it 'renders the new template again' do
					expect do
						post :create, incoming_event: { title: '' }
					end.not_to change{ IncomingEvent.count }
					response.should render_template 'new'
				end
			end

			context 'with valid data' do
				it 'creates a new record' do
					expect do
						post :create, incoming_event: FactoryGirl.attributes_for(:incoming_event)
					end.to change{ IncomingEvent.count }.by(1)
					response.should redirect_to incoming_event_path(assigns(:incoming_event))
					flash[:notice].should_not be_blank
				end
			end

			context 'with forward matching expected_event' do
				it 'finds expected event by its title' do
					existing_event_expectation = FactoryGirl.create(:expected_event)
					post :create, incoming_event: { title: existing_event_expectation.title }
					assigns(:expected_event).should eql existing_event_expectation
					pending "TODO run alarm triggers"
				end
			end
		end
	end

	context 'without being logged in' do
		describe 'POST create' do
			it 'requires log in' do
				expect do
					post :create, incoming_event: FactoryGirl.attributes_for(:incoming_event)
				end.not_to change{ IncomingEvent.count }
				expect(response).to redirect_to login_path
				expect(flash[:alert]).to eql 'Not authorized'
			end
		end
	end

	[:json, :xml].each do |format|
		context "as #{format} request" do
			describe 'POST create' do
				context 'with valid api token' do
					context 'assigns remote side to incoming event' do
						let(:remote_side) { FactoryGirl.create(:remote_side) }
							it 'assigns corresponding remote side' do
								post :create, incoming_event: { title: "my title" }, api_token: remote_side.api_token, format: :xml
								assigns(:incoming_event).reload.remote_side.should eql remote_side
							end
					end
				end

				context 'with valid api token' do
					let(:api_token) { FactoryGirl.create(:remote_side).api_token }

					it 'creates a new record' do
						expect do
							post :create, incoming_event: { title: "my title" }, api_token: api_token, format: format
						end.to change{ IncomingEvent.count }.by(1)
						expect(response.code).to eql "201"
					end

					it 'fails to create record' do
						expect do
							post :create, incoming_event: { title: " " }, api_token: api_token, format: format
						end.not_to change{ IncomingEvent.count }
						expect(response.code).to eql "422"
					end
				end
			end

			context 'with invalid api token' do
				it 'returns unauthorized (401) when an api token is not provided' do
					post :create, format: format
					expect(response).to be_forbidden
				end

				it 'returns unauthorized (401) when an api token is incorrect' do
					post :create, api_token: "asdfghjkl", format: format
					expect(response).to be_forbidden
				end
			end
		end
	end

end


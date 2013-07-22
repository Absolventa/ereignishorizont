require 'spec_helper'

describe IncomingEventsController do
	render_views

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

		context 'with matching expected_event' do
			it 'finds expected event by its title' do
				expected_event = FactoryGirl.create(:expected_event)
				post :create, incoming_event: { title: expected_event.title }
				assigns(:expected_event).should eql expected_event
				#expected_event.where(:incoming_event).should eql expected_event (Tam's attempt)
			end
		end
	end

end

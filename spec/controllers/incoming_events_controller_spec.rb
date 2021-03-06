require 'rails_helper'

describe IncomingEventsController, :type => :controller do
  render_views

  context 'as html format' do
    before do
      allow(controller).to receive(:logged_in?).and_return(true)
    end

    describe 'GET index' do
      it "renders all incoming events" do
        incoming_event = FactoryGirl.create(:incoming_event)
        get :index
        expect(response).to be_success
        expect(response).to render_template 'index'
        expect(assigns(:incoming_events).to_a).to eql [incoming_event]
      end

      it_behaves_like 'searches by title'
      it_behaves_like 'filters by remote'

    end

    describe 'GET show' do
      it 'renders a single incoming event' do
        incoming_event = FactoryGirl.create(:incoming_event)
        get :show, params: { id: incoming_event.id }
        expect(response).to be_success
        expect(response).to render_template 'show'
        expect(assigns(:incoming_event)).to eql incoming_event
      end
    end

    describe 'GET new' do
      it 'renders the new form' do
        get :new
        expect(response).to be_success
        expect(response).to render_template 'new'
        expect(response).to render_template '_form'
        expect(assigns(:incoming_event)).not_to be_nil
      end
    end

    describe 'POST create' do
      context 'with invalid data' do
        it 'renders the new template again' do
          expect do
            post :create, params: { incoming_event: { title: '' } }
          end.not_to change{ IncomingEvent.count }
          expect(response).to render_template 'new'
        end
      end

      context 'with valid data' do
        it 'creates a new record' do
          expect do
            post :create, params: { incoming_event: FactoryGirl.attributes_for(:incoming_event) }
          end.to change{ IncomingEvent.count }.by(1)
          expect(response).to redirect_to incoming_event_path(assigns(:incoming_event))
          expect(flash[:notice]).not_to be_blank
        end
      end

      context 'with forward matching expected_event' do
        let(:existing_event_expectation) { FactoryGirl.create(:expected_event) }
        let(:incoming_event_attributes)  { { title: existing_event_expectation.title } }

        subject do
          post :create, params: { incoming_event: incoming_event_attributes }
        end

        it 'finds expected event by its title' do
          post :create, params: { incoming_event: { title: existing_event_expectation.title } }
          expect(assigns(:expected_event)).to eql existing_event_expectation
        end

        it 'runs alarms for matching forward event expectation' do
          expect_any_instance_of(ExpectedEvent).to receive(:alarm!).and_call_original
          post :create, params: { incoming_event: { title: existing_event_expectation.title } }
        end

        context 'with a mail alarm' do
          before do
            incoming_event_attributes[:content] = 'I cannot let you do that, Dave'
            existing_event_expectation.alarms << alarm
          end

          let(:alarm) { create :alarm, action: 'email' }

          it 'passes the optional content to the mail' do
            perform_enqueued_jobs do
              expect { subject }.to change \
                { ActionMailer::Base.deliveries.size }.by(1)
            end

            mail = ActionMailer::Base.deliveries.last
            expect(mail.body.to_s).to match 'I cannot let you do that, Dave'
          end
        end
      end
    end
  end

  context 'without being logged in' do
    describe 'POST create' do
      it 'requires log in' do
        expect do
          post :create, params: { incoming_event: FactoryGirl.attributes_for(:incoming_event) }
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
              post :create, params: { incoming_event: { title: "my title" }, api_token: remote_side.api_token, format: :xml }
              expect(assigns(:incoming_event).reload.remote_side).to eql remote_side
            end
          end
        end

        context 'with valid api token' do
          let(:api_token) { FactoryGirl.create(:remote_side).api_token }

          it 'creates a new record' do
            expect do
              post :create, params: { incoming_event: { title: "my title" }, api_token: api_token, format: format }
            end.to change{ IncomingEvent.count }.by(1)
            expect(response.code).to eql "201"
          end

          it 'fails to create record' do
            expect do
              post :create, params: { incoming_event: { title: " " }, api_token: api_token, format: format }
            end.not_to change{ IncomingEvent.count }
            expect(response.code).to eql "422"
          end
        end
      end

      context 'with invalid api token' do
        it 'returns unauthorized (401) when an api token is not provided' do
          post :create, params: { format: format }
          expect(response).to be_forbidden
        end

        it 'returns unauthorized (401) when an api token is incorrect' do
          post :create, params: { api_token: "asdfghjkl", format: format }
          expect(response).to be_forbidden
        end
      end
    end
  end

end

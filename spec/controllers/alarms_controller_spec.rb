require 'spec_helper'

describe AlarmsController, :type => :controller do
  render_views

  let(:user) { mock_model(User, admin?: false) }

  before do
    allow(controller).to receive(:current_user).and_return(user)
  end

  let(:alarm) { FactoryGirl.create(:alarm) }

  describe 'GET index' do
    it 'renders the "index" template' do
      alarm
      get :index
      expect(response).to be_success
      expect(response).to render_template :index
    end

    it 'filters by assigned expected_event' do
      expected_event = FactoryGirl.create(:expected_event)
      alarm.expected_events << expected_event
      FactoryGirl.create(:alarm)
      get :index, expected_event_id: expected_event.id
      expect(assigns(:alarms).to_a).to eql [alarm]
    end
  end

  describe 'GET show' do
    it 'renders the "show" template' do
      get :show, id: alarm.to_param
      expect(response).to be_success
      expect(response).to render_template :show
    end
  end

  describe 'GET run' do
    it 'sounds an alarm and redirects' do
      get :run, id: alarm.to_param
      expect(response).to redirect_to alarms_path
    end
  end

  describe 'GET new' do
    it 'renders the "new" template' do
      get :new
      expect(response).to be_success
      expect(response).to render_template :new
    end
  end

  describe 'POST create' do
    it 'renders the "new" template' do
      invalid_params = FactoryGirl.attributes_for(:alarm).merge(action: '')
      expect do
        post :create, alarm: invalid_params
      end.not_to change { Alarm.count }
      expect(response).to render_template 'new'
    end

    it 'creates a record and redirects' do
      expect do
        post :create, alarm: FactoryGirl.attributes_for(:alarm)
      end.to change { Alarm.count }
      expect(response).to redirect_to alarm_path(assigns(:alarm))
    end

    it 'removes the email address unless selected action is email' do
      attributes = FactoryGirl.attributes_for(:alarm, action: 'logger', email_recipient: 'foo@bar.com')
      post :create, alarm: attributes
      expect(assigns(:alarm).email_recipient).to be_nil
    end
  end

  describe 'PATCH update' do
    it 'renders the "edit" template' do
      patch :update, id: alarm.to_param, alarm: { action: '' }
      expect(response).to render_template 'edit'
    end

    it 'updates a record and redirects' do
      patch :update, id: alarm.to_param, alarm: { title: 'Foo' }
      expect(response).to redirect_to alarm_path(assigns(:alarm))
    end
  end

  describe 'DELETE destroy' do
    before { alarm }

    it 'destroys the record and redirects to index' do
      expect {
        delete :destroy, id: alarm.to_param
      }.to change { Alarm.count }.by(-1)

      expect(flash[:notice]).not_to be_blank
      expect(response).to redirect_to alarms_path
    end
  end
end

require 'spec_helper'

describe ExpectedEventsController do
  render_views

  before do
    controller.stub(:logged_in?).and_return(true)
  end

  let(:expected_event) { FactoryGirl.create(:expected_event) }

  describe 'GET index' do
    it "renders the 'index' template" do
      expected_event
      get :index
      expect(response).to render_template 'index'
    end

    it_behaves_like 'searches by title'

  end

  describe 'POST create' do
    let(:remote_side) { FactoryGirl.create(:remote_side) }
    let(:valid_attributes) { FactoryGirl.attributes_for(:expected_event) }

    it 'creates a new record' do
      expect do
        post :create, expected_event: valid_attributes.merge(remote_side_id: remote_side.id)
      end.to change { ExpectedEvent.count }.by(1)
      expect(flash[:notice]).not_to be_blank
      expect(response).to redirect_to expected_event_path(assigns(:expected_event))
    end

    it 'renders the "new" template' do
      expect do
        post :create, expected_event: { title: '' }
      end.not_to change { ExpectedEvent.count }
      expect(response).to render_template 'new'
    end

    it 'accepts associating with alarms' do
      alarm = FactoryGirl.create(:alarm)
      post :create, expected_event: valid_attributes.merge("alarm_ids" => [alarm.id])
      expect(assigns(:expected_event).alarms).to include alarm
    end
  end

  describe 'PATCH update' do
    let(:valid_attributes) { { title: 'Foobar' } }

    it 'creates a new record' do
      expect do
        patch :update, id: expected_event.to_param, expected_event: valid_attributes
      end.to change { expected_event.reload.title }
      expect(flash[:notice]).not_to be_blank
      expect(response).to redirect_to expected_event_path(assigns(:expected_event))
    end

    it 'renders the "edit" template' do
      expect do
        patch :update, id: expected_event.to_param, expected_event: { title: '' }
      end.not_to change { expected_event.reload.title }
      expect(response).to render_template 'edit'
    end

    it 'accepts associating with alarms' do
      alarm = FactoryGirl.create(:alarm)
      patch :update, id: expected_event.to_param, expected_event: { "alarm_ids" => [alarm.id] }
      expect(assigns(:expected_event).alarms).to include alarm
    end
  end
end

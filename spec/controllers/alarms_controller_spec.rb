require 'spec_helper'

describe AlarmsController do
  render_views

  before do
    controller.stub(:logged_in?).and_return(true)
  end

  let(:alarm) { FactoryGirl.create(:alarm) }

  describe 'GET index' do
    it 'renders the "index" template' do
      alarm
      get :index
      expect(response).to be_success
      expect(response).to render_template :index
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
      Alarm.any_instance.should_receive(:run)
      get :run, id: alarm.to_param
      expect(response).to redirect_to alarms_path
    end
  end
end

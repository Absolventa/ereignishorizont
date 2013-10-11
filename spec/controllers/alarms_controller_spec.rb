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
end

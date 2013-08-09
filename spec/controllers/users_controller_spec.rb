require 'spec_helper'

describe UsersController do
  render_views

  before do
    @user = FactoryGirl.create(:user, admin: false)
    controller.stub(:current_user).and_return(@user)
  end

  describe 'GET index' do
    context 'as admin' do
      it 'renders a list of all users' do
        User.any_instance.stub(:admin?).and_return(true)
        get :index
        expect(response).to render_template 'index'
      end
    end

    context 'as normal user' do
      it 'redirects to incoming_events#index' do
        get :index
        expect(response).to redirect_to incoming_events_path
      end
    end
  end

end

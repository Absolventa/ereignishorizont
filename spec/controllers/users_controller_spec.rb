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
        expect(flash[:alert]).to eql "Not authorized"
      end
    end
  end

  describe 'GET new' do
    context 'as admin' do
      it "renders the 'new' template" do
        User.any_instance.stub(:admin?).and_return(true)
        get :new
        expect(response).to render_template 'new'
      end
    end

    context 'as normal user' do
      it 'redirects to users#show' do
        get :new
        expect(response).to redirect_to user_path(@user)
        expect(flash[:alert]).to eql "Not authorized"
      end
    end
  end

  describe 'GET edit' do
    context 'as admin' do
      it "renders the 'edit' template" do
        User.any_instance.stub(:admin?).and_return(true)
        other_user = FactoryGirl.create(:user)
        get :edit, id: other_user.id
        expect(response).to render_template 'edit'
        expect(assigns(:user)).to eql other_user
      end
    end

    context 'as normal user' do
      it 'renders the current users "edit" template' do
        get :edit, id: 'nonexistent_id'
        expect(response).to render_template 'edit'
        expect(assigns(:user)).to eql @user
      end
    end
  end

  describe 'POST create' do
    context 'as admin' do

      before do
        User.any_instance.stub(:admin?).and_return(true)
      end

      it 'creates a new record from valid params' do
        attributes = FactoryGirl.attributes_for(:user)
        expect do
          post :create, user: attributes
        end.to change{User.count}.by(1)
        expect(response).to redirect_to users_path
      end
      it "renders 'new' template for invalid params" do
        expect do
          post :create, user: {email:""}
        end.not_to change{User.count}
        expect(response).to render_template 'new'
      end
    end
    context 'as normal user' do
      it 'redirects to root_path' do
        post :create
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to eql "Not authorized"
      end
    end
  end

  describe 'PATCH update' do
    context 'as admin' do
      before do
        User.any_instance.stub(:admin?).and_return(true)
      end

      it 'successfully updates other user and redirects' do
        other_user = FactoryGirl.create(:user)
        User.any_instance.stub(:valid?).and_return(true)
        patch :update, id: other_user.to_param, user: { email: '' }
        expect(flash[:notice]).not_to be_blank
        expect(response).to redirect_to user_path(other_user)
      end

      it "fails to update other user and renders 'edit' template" do
        other_user = FactoryGirl.create(:user)
        User.any_instance.stub(:valid?).and_return(false)
        patch :update, id: other_user.to_param, user: { email: '' }
        expect(flash[:notice]).to be_blank
        expect(response).to render_template 'edit'
      end
    end

    context 'as a normal user' do
      it 'updates current user' do
        User.any_instance.stub(:valid?).and_return(true)
        patch :update, id: @user.to_param, user: { email: '' }
        expect(flash[:notice]).not_to be_blank
        expect(response).to redirect_to user_path(@user)
      end

      it "fails to update current user and renders 'edit' template" do
        User.any_instance.stub(:valid?).and_return(false)
        patch :update, id: @user.to_param, user: { email: '' }
        expect(flash[:notice]).to be_blank
        expect(response).to render_template 'edit'
      end
    end
  end

  describe 'DELETE destroy' do
    context 'as admin' do
      it 'destroys other user' do
        pending
      end
    end
    context 'as normal user' do
      it 'redirects to users#show' do
        pending
      end
    end
  end
end

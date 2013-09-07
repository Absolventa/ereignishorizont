require 'spec_helper'

describe PasswordResetsController do
  render_views

  describe 'GET new' do
    it "renders the 'new' template" do
      get :new
      expect(response).to be_success
      expect(response).to render_template 'new'
    end
  end

  describe 'POST create' do
    it 'finds user by email and sends reset instructions' do
      user = FactoryGirl.create(:user)
      expect do
        post :create, email: user.email
      end.to change{ ActionMailer::Base.deliveries.size }.by(1)
      expect(flash[:notice]).not_to be_blank
      expect(response).to redirect_to root_path
    end

    it 'does not give away existence of email' do
      expect do
        post :create, email: "nonexistent@example.com"
      end.not_to change{ ActionMailer::Base.deliveries.size }
      expect(flash[:notice]).to eql "Password reset instructions sent."
    end
  end

  describe 'GET edit' do
    it 'returns a hard error when email reset token is unknown' do
      expect do
        get :edit, id: "qwerty"
      end.to raise_exception ActiveRecord::RecordNotFound
    end

    it 'finds user by reset token renders the edit template' do
      user = FactoryGirl.create(:user, password_reset_token: 'qwerty')
      get :edit, id: "qwerty"
      expect(response).to be_success
      expect(response).to render_template 'edit'
      expect(assigns(:user)).to eql user
    end
  end
end

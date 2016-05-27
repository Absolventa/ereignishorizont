require 'spec_helper'

describe PasswordResetsController, :type => :controller do
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
      perform_enqueued_jobs do
        expect { post :create, params: { email: user.email } }.to \
          change{ ActionMailer::Base.deliveries.size }.by(1)
      end
      expect(flash[:notice]).not_to be_blank
      expect(response).to redirect_to root_path
    end

    it 'does not give away existence of email' do
      expect do
        post :create, params: { email: "nonexistent@example.com" }
      end.not_to change{ ActionMailer::Base.deliveries.size }
      expect(flash[:notice]).to eql "Password reset instructions sent."
    end
  end

  describe 'GET edit' do
    it 'returns a hard error when email reset token is unknown' do
      expect do
        get :edit, params: { id: "qwerty" }
      end.to raise_exception ActiveRecord::RecordNotFound
    end

    it 'finds user by reset token renders the edit template' do
      user = FactoryGirl.create(:user, password_reset_token: 'qwerty')
      get :edit, params: { id: "qwerty" }
      expect(response).to be_success
      expect(response).to render_template 'edit'
      expect(assigns(:user)).to eql user
    end
  end

  describe 'PATCH update' do
    let(:passwords) do
      { password: 'helloworld', password_confirmation: 'helloworld' }
    end

    it 'returns a hard error when email reset token is unknown' do
      expect do
        patch :update, params: { id: "qwerty" }
      end.to raise_exception ActiveRecord::RecordNotFound
    end

    it 'fails if password_reset_token is older than two hours' do
      user = FactoryGirl.create(:user,
                                password_reset_token: 'qwerty',
                                password_reset_sent_at: 121.minutes.ago
                               )
      expect do
        patch :update, params: { id: user.password_reset_token, user: passwords }
      end.not_to change{ user.reload.password_digest }
      expect(response).to redirect_to new_password_reset_path
      expect(flash[:alert]).to match 'expired'
    end

    context 'with a recently sent token' do
      let(:user) do
        user = FactoryGirl.build(:user)
        user.send_password_reset
        user
      end

      it 'updates the password and logs user in' do
        expect do
          patch :update, params: { id: user.password_reset_token, user: passwords }
        end.to change{ user.reload.password_digest }
        expect(response).to redirect_to root_path
        expect(flash[:notice]).not_to be_blank
        expect(cookies[:auth_token]).to eql user.auth_token
      end

      it 'fails to update user and renders edit' do
        allow_any_instance_of(User).to receive(:valid?).and_return(false)
        expect do
          patch :update, params: { id: user.password_reset_token, user: passwords }
        end.not_to change{ user.reload.password_digest }
        expect(response).to render_template 'edit'
      end
    end
  end

end

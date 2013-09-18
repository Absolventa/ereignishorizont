require 'spec_helper'

	#testing for secure password goes in authentication tests?

	describe User do

		it { should validate_presence_of :email }
		it { should ensure_length_of(:password).is_at_least(5) }
		it { should_not allow_value("blah").for(:email) }
		it { should allow_value("a@b.com").for(:email) }


		it "has a valid factory" do
	  	FactoryGirl.create(:user).should be_valid
		end

		context 'validating email address' do
			it "is invalid with a duplicate email address" do
				FactoryGirl.create(:user, email: "tam@testemail.com")
				FactoryGirl.build(:user, email: "tam@testemail.com").should_not be_valid
			end

			it "is valid when there is an email address" do
				FactoryGirl.build(:user, email: "johndoe@example.com").should be_valid
			end
		end

    # OPTIMIZE This does not not necessarily test the validations on #password.
    # The record could be invalid for many other reasons (CZ)
		context 'validating password' do
			it "is invalid without a password" do
				FactoryGirl.build(:user, password: nil).should_not be_valid
			end

			it "is invalid without a password confirmation" do
				FactoryGirl.build(:user, password_confirmation: nil).should_not be_valid
			end
		end
	end

  describe '#send_password_reset' do
    let(:user) { FactoryGirl.build(:user) }

    it 'saves the record without validating it' do
      user.should_receive(:save!).with(validate: false)
      user.send_password_reset
    end

    it 'sets the password_reset_token' do
      expect do
        user.send_password_reset
      end.to change{ user.password_reset_token }
    end

    it 'sends an email' do
      expect do
        user.send_password_reset
      end.to change{ ActionMailer::Base.deliveries.size }.by(1)
      expect(ActionMailer::Base.deliveries.last.to).to include user.email
    end

    it 'tracks the time of the password reset request' do
      expect do
        user.send_password_reset
      end.to change{ user.password_reset_sent_at }
    end
  end

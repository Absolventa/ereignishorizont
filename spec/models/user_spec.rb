require 'spec_helper'

describe User, :type => :model do

  it { expect(subject).to validate_presence_of :email }
  it { expect(subject).to ensure_length_of(:password).is_at_least(5) }
  it { expect(subject).to_not allow_value("blah").for(:email) }
  it { expect(subject).to allow_value("a@b.com").for(:email) }

  it 'has a valid factory' do
    expect(FactoryGirl.build(:user)).to be_valid
  end

  context 'validating email address' do
    it 'is invalid with a duplicate email address' do
      FactoryGirl.create(:user, email: 'tam@testemail.com')
      expect(FactoryGirl.build(:user, email: 'tam@testemail.com')).not_to be_valid
    end

    it 'is valid when there is an email address' do
      expect(FactoryGirl.build(:user, email: 'johndoe@example.com')).to be_valid
    end
  end

  # OPTIMIZE This does not not necessarily test the validations on #password.
  # The record could be invalid for many other reasons (CZ)
  context 'validating password' do
    it 'is invalid without a password' do
      expect(FactoryGirl.build(:user, password: nil)).not_to be_valid
    end

    it 'is invalid without a password confirmation' do
      user = FactoryGirl.build(:user, password_confirmation: '')
      expect(user).not_to be_valid
    end

    context 'on update' do
      let(:user) { FactoryGirl.create(:user); User.last }

      context 'is valid if' do
        it 'has no password and no password confirmation set' do
          user.password_confirmation = ''

          expect(user).to be_valid
        end

        it 'has no password and a password confirmation set' do
          user.password_confirmation = 'forgot to enter password'

          expect(user).to be_valid
        end
      end

      context 'is invalid if' do
        it 'has an unconfirmed password' do
          user.password = 'even more secret'
          user.password_confirmation = ''

          expect(user).to have(1).errors_on(:password_confirmation)
          expect(user.errors_on(:password_confirmation)).
            to include("doesn't match Password")
        end

        it 'has different password and password confirmation set' do
          user.password = 'more secret'
          user.password_confirmation = 'but with typo'

          expect(user).to have(1).errors_on(:password_confirmation)
          expect(user.errors_on(:password_confirmation)).
            to include("doesn't match Password")
        end
      end
    end
  end

  describe '#send_password_reset' do
    let(:user) { FactoryGirl.create(:user) }

    it 'saves the record without validating it' do
      expect(user).to receive(:save!).with(validate: false).and_call_original
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
end

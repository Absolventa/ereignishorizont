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

		context 'validating password' do
			it "is invalid without a password" do
				FactoryGirl.build(:user, password: nil).should_not be_valid
			end

			it "is invalid without a password confirmation" do
				FactoryGirl.build(:user, password_confirmation: nil).should_not be_valid
			end
		end
	end

		#These do not work because they are testing the wrong thing!
			# it "should be valid with long enough password" do
			# 	FactoryGirl.build(:user, password: "12345678").should be_valid
			# end

			# it "should not be valid with short password" do
			# 	FactoryGirl.build(:user, password: "1234567").should_not be_valid
			# end

			# it "should not be valid with a really long password" do
			# 	FactoryGirl.build(:user, password: "123456789012345678901").should_not be_valid
			# end

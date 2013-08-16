require 'spec_helper'

describe SessionsController do

  
  context "as logged in user" do
		before do
  		@user = FactoryGirl.create(:user, admin: false)
  		controller.stub(:current_user).and_return(@user)
		end

  	describe "GET 'new'" do
    	it "redirects to root URL" do
      	get 'new'
        expect(response).to redirect_to root_path
    	end
  	end
	end

end

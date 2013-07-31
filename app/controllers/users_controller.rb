class UsersController < ApplicationController

respond_to :html

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
      
      if @user.save
        redirect_to root_url
        flash[:notice] = "Zank u for signing up!"
      else
        render action: "new"
        flash[:error] = "Your sign in sucked"
      end
      
  end


  private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
end



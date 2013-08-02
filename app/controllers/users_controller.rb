class UsersController < ApplicationController

  before_action :authorize, only: [:show, :edit, :update]

respond_to :html

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
      
      if @user.save
        redirect_to incoming_events_path
        session[:user_id] = @user.id
        flash[:notice] = "Zank u for signing up!"
      else
        render action: "new"
        flash[:error] = "Your sign up sucked"
      end
      
  end


  private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
end



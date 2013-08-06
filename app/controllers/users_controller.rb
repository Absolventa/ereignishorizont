class UsersController < ApplicationController

  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :authorize, only: [:show, :edit, :update]

respond_to :html

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
      
      if @user.save
        redirect_to incoming_events_path
        cookies[:auth_token] = @user.auth_token
        flash[:notice] = "Zank u for signing up!"
      else
        render action: "new"
        flash[:error] = "Your sign up sucked"
      end
      
  end

  def show
    @current_user ||= User.find_by_auth_token( cookies[:auth_token]) if cookies[:auth_token]
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User successfully updated' }
      else
        format.html { render action: 'edit'}
      end
    end
  end



  private

      def set_user
        @user = current_user
      end

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :auth_token)
    end
end



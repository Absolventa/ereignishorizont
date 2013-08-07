class UsersController < ApplicationController

 
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  skip_before_action :authorize

respond_to :html

  def index
    @users = User.all
    
  end

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

    #def set_user
    #  @user = current_user
    #end

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :auth_token)
    end

    def set_user
      if current_user.admin?
        @user = User.find(params[:id])
      else
        @user = current_user
      end
    end
end



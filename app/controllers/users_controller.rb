class UsersController < ApplicationController

respond_to :html

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
      format.html { redirect_to root_url, notice: "Zank u for signing up!" }
      else
      format.html { render action: "new" }
      end
    end
  end


  private

def user_params
  params.require(:user).permit(:email, :password, :password_confirmation)
end
end



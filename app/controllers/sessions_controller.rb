class SessionsController < ApplicationController
  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to incoming_events_path, notice: "Logged in!"
    else
      redirect_to root_url
      flash[:error] = "Email or password is invalid."
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "Logged out!"
  end
end



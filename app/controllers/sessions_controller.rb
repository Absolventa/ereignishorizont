class SessionsController < ApplicationController

#how do we add an email validation to the session? There is no model!

  def new
  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      if params[:remember_me]
        cookies.permanent[:auth_token] = user.auth_token
      else
        cookies[:auth_token] = user.auth_token
      end
      redirect_to incoming_events_path, notice: "Logged in!"
    else
      redirect_to root_url
      flash[:error] = "Email or password is invalid."
    end
  end

  def destroy
    cookies.delete(:auth_token)
    redirect_to root_url, notice: "Logged out!"
  end
end



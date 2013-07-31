class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  private
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
    # short form for: 
    # @current_user = @current_user || User.find(session[:user_id]) if session[:user_id]
    # if @current_user = @current_user then the expression stops and is true
    # if @current user does not equal current user, than the second part of the
    # expression is evaluated. (See Tobi's email) 
  end
  helper_method :current_user
end

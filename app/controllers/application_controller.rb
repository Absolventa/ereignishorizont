class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authorize

  private
  def current_user
    @current_user ||= User.find_by_auth_token( cookies[:auth_token]) if cookies[:auth_token]

  end
  helper_method :current_user

  def logged_in?
    current_user.present?
  end

  def authorize
    redirect_to login_path, alert: "Not authorized" unless logged_in?
  end

end

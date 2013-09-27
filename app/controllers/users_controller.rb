class UsersController < ApplicationController

  helper_method :sort_column, :sort_direction
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    if current_user.admin?
      @users = User.order(sort_column + ' ' + sort_direction)
    else
      redirect_to incoming_events_path, alert: "Not authorized"
    end
  end

  def new
    if current_user.admin?
      @user = User.new
    else
      redirect_to user_path(current_user), alert: "Not authorized"
    end
  end

  def create
    if current_user.admin?
      @user = User.new(user_params)

      if @user.save
        redirect_to users_path
        flash[:notice] = "User #{@user.email} created."
      else
        render action: "new"
        flash[:error] = "Admin privileges required."
      end
    else
      redirect_to root_path, alert: "Not authorized"
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

  def destroy
    if current_user.admin?
      @user.destroy
      redirect_to users_path , notice: 'User has been deleteted.'
    else
      redirect_to users_path, alert: "Not authorized"
    end
  end

  private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :auth_token)
    end

    def set_user
      @user = if current_user.admin?
                User.find(params[:id])
              else
                current_user
              end
    end

    def sort_column
      User.column_names.include?(params[:sort]) ? params[:sort] : "email"
    end

    def sort_direction
      %w[asc desc]. include?(params[:direction]) ? params[:direction] : "asc"
    end

end

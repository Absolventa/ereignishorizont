class RemoteSidesController < ApplicationController

  # before_action :set_remote_side, only [:show, :edit, :update, :destroy, :new]
  respond_to :html

  def index
    @remote_sides = RemoteSide.all
  end

  def show
  end

  def new
    @remote_side = RemoteSide.new
  end

  def edit
  end

  def create
    @remote_side = RemoteSide.new(remote_side_params)
    respond_to do |format|
      if @remote_side.save
        format.html { redirect_to @remote_side, notice: 'Remote side was successfully created' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  def update
    respond_to do |format|
      if @remote_side.update(remote_side_params)
        format.html { redirect_to @remote_side, notice: 'Remote side was successfully updated' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    @remote_side.destroy
    respond_to do |format|
      format.html { redirect_to remote_side_url }
    end
  end

private

  def set_remote_side
    @remote_side = RemoteSide.find(params[:id])
  end

  def remote_side_params
    params.require(:remote_side).permit([:title, :api_token])
  end
end
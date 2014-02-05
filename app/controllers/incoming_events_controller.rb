class IncomingEventsController < ApplicationController

  skip_before_filter :verify_authenticity_token, if: :remote_side_request?
  skip_before_action :authorize,  only: :create
  before_action :restrict_access, only: :create

  before_action :set_incoming_event, only: [:show, :edit, :update, :destroy]

  helper_method :sort_column, :sort_direction

  def index
    search_term = params.fetch(:query, {})[:title]
    @incoming_events = if search_term
                         IncomingEvent.where("title ILIKE :query", query: "%#{search_term}%")
                       else
                         IncomingEvent
                       end
    @incoming_events = @incoming_events.order(sort_column + ' ' + sort_direction)
      .page(params[:page]).per_page(10)
  end

  def show
    respond_to do |format|
      format.html
    end
  end

  def new
    @incoming_event = IncomingEvent.new
  end

  def edit
  end

  def create
    @incoming_event = IncomingEvent.new(incoming_event_params)
    @incoming_event.remote_side = remote_side

    respond_to do |format|
      if @incoming_event.save
        @expected_event = ExpectedEvent.forward.where(title: @incoming_event.title).first
        @expected_event.alarm! if @expected_event

        format.json { render json: @incoming_event.to_json, status: :created }
        format.xml  { render xml:  @incoming_event.to_xml,  status: :created }
        format.html { redirect_to @incoming_event, notice: 'Incoming event was successfully created.' }
      else
        format.json { render json: @incoming_event.errors.to_json, status: :unprocessable_entity }
        format.xml  { render xml:  @incoming_event.errors.to_xml,  status: :unprocessable_entity }
        format.html { render action: 'new' }
      end
    end
  end

  def update
    respond_to do |format|
      if @incoming_event.update(incoming_event_params)
        format.html { redirect_to @incoming_event, notice: 'Incoming event was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    @incoming_event.destroy
    respond_to do |format|
      format.html { redirect_to incoming_events_url }
    end
  end

  private

  def set_incoming_event
    @incoming_event = IncomingEvent.find(params[:id])
  end

  def incoming_event_params
    params.require(:incoming_event).permit(:title, :content)
  end

  def sort_column
    IncomingEvent.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "DESC"
  end

  def restrict_access
    if remote_side_request?
      render nothing: true, status: :forbidden unless remote_side
    else
      authorize
    end
  end

  def remote_side_request?
    request.format.xml? || request.format.json?
  end

  def remote_side
    @remote_side ||= RemoteSide.find_by_api_token(params[:api_token])
  end

end

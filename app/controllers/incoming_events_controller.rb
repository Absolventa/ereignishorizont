class IncomingEventsController < ApplicationController

  # TODO - we need this as a step inbetween the remote side and the user - a machine can create an incoming event
  #skip_before_action :login_required, only: :create

  helper_method :sort_column, :sort_direction
  before_action :set_incoming_event, only: [:show, :edit, :update, :destroy]

  def index
    @incoming_events = IncomingEvent.order(sort_column + ' ' + sort_direction)
  end

  def show
    respond_to do |format|
      format.html
      format.xml { render xml: @incoming_event.to_xml }
      format.json { render json: @incoming_event.to_json }
    end
  end

  def new
    @incoming_event = IncomingEvent.new
  end

  def edit
  end

  def create
    @incoming_event = IncomingEvent.new(incoming_event_params)

    # when api token present: assign corresponding remote site

    respond_to do |format|
      if @incoming_event.save

        # TODO Find expected event (if any) and make it do its stuff <- Carsten
        @expected_event = ExpectedEvent.forward.where(title: @incoming_event.title).first
        # @expected_event.alarm! if @expected_event # <- Carsten


        format.html { redirect_to @incoming_event, notice: 'Incoming event was successfully created.' }
      else
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
      params.require(:incoming_event).permit(:title)
    end

    def sort_column
      IncomingEvent.column_names.include?(params[:sort]) ? params[:sort] : "title"
    end

    def sort_direction
      %w[asc desc]. include?(params[:direction]) ? params[:direction] : "asc"
    end


end

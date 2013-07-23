class IncomingEventsController < ApplicationController
  before_action :set_incoming_event, only: [:show, :edit, :update, :destroy]

  # GET /incoming_events
  def index
    @incoming_events = IncomingEvent.all
  end

  # GET /incoming_events/1
  def show
  end

  # GET /incoming_events/new
  def new
    @incoming_event = IncomingEvent.new
  end

  # GET /incoming_events/1/edit
  def edit
  end

  # POST /incoming_events
  def create
    @incoming_event = IncomingEvent.new(incoming_event_params)

    respond_to do |format|
      if @incoming_event.save

        # TODO Find expected event (if any) and make it do its stuff
        @expected_event = ExpectedEvent.where(title: @incoming_event.title).first
        #@expected_event.alarm!

        format.html { redirect_to @incoming_event, notice: 'Incoming event was successfully created.' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  # PATCH/PUT /incoming_events/1
  def update
    respond_to do |format|
      if @incoming_event.update(incoming_event_params)
        format.html { redirect_to @incoming_event, notice: 'Incoming event was successfully updated.' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  # DELETE /incoming_events/1
  # DELETE /incoming_events/1.json
  def destroy
    @incoming_event.destroy
    respond_to do |format|
      format.html { redirect_to incoming_events_url }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_incoming_event
      @incoming_event = IncomingEvent.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def incoming_event_params
      params.require(:incoming_event).permit(:title)
    end
end

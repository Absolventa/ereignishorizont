class IncomingEventsController < ApplicationController
  before_action :set_incoming_event, only: [:show, :edit, :update, :destroy]

  # GET /incoming_events
  # GET /incoming_events.json
  def index
    @incoming_events = IncomingEvent.all
  end

  # GET /incoming_events/1
  # GET /incoming_events/1.json
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
  # POST /incoming_events.json
  def create
    @incoming_event = IncomingEvent.new(incoming_event_params)

    respond_to do |format|
      if @incoming_event.save

        # TODO Find expected event (if any) and make it do its stuff
        @expected_event = ExpectedEvent.where(title: @incoming_event.title).first
        #@expected_event.alarm!

        format.html { redirect_to @incoming_event, notice: 'Incoming event was successfully created.' }
        format.json { render action: 'show', status: :created, location: @incoming_event }
      else
        format.html { render action: 'new' }
        format.json { render json: @incoming_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /incoming_events/1
  # PATCH/PUT /incoming_events/1.json
  def update
    respond_to do |format|
      if @incoming_event.update(incoming_event_params)
        format.html { redirect_to @incoming_event, notice: 'Incoming event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @incoming_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /incoming_events/1
  # DELETE /incoming_events/1.json
  def destroy
    @incoming_event.destroy
    respond_to do |format|
      format.html { redirect_to incoming_events_url }
      format.json { head :no_content }
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

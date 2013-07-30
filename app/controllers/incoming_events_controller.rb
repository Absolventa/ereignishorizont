class IncomingEventsController < ApplicationController
  before_action :set_incoming_event, only: [:show, :edit, :update, :destroy]

  def index
    @incoming_events = IncomingEvent.all
  end

  def show
  end

  def new
    @incoming_event = IncomingEvent.new
  end

  def edit
  end

  def create
    @incoming_event = IncomingEvent.new(incoming_event_params)

    respond_to do |format|
      if @incoming_event.save

        # TODO Find expected event (if any) and make it do its stuff <- Carsten
        @expected_event = ExpectedEvent.where(title: @incoming_event.title).first
        #@expected_event.alarm! <- Carsten

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
end

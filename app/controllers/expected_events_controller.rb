class ExpectedEventsController < ApplicationController
  before_action :set_expected_event, only: [:show, :edit, :update, :destroy]
  #buttons to show, edit, update and destroy only show up when 
  #someone has entered an expected event. 

  #respond_to :html, :json

  #GET /expected_events
  #GET /expected_events.json
  def index
  	@expected_events = ExpectedEvent.all
  end
  
  #GET /expected_events/1
  #GET /expected_events/1.json
  def show
  end

  #GET /expected_events/new
  def new
  	@expected_event = ExpectedEvent.new
  end

  #GET /expected_events/1/edit
  def edit
  end

  #POST /expected_events
  #POST /expected_events.json
  def create
  	@expected_event = ExpectedEvent.new(expected_event_params)

  	respond_to do |format|
  		if @expected_event.save
  			format.html { redirect_to @expected_event, notice: 'Incoming event was successfully created'}
  			format.json { render action: 'show', status: :created, location: @expected_event }
  		else
  			format.html { render action: 'new' }
  			format.json { render json: @expected_event.errors, status: :unprocessable_entry }
  		end
  	end
  end

  #PATCH/PUT /expected_events/1
  #PATCH/PUT /expected_events/1.json

  def update
  	respond_to do |format|
  		if @expected_event.update(expected_event_params)
  			format.html { redirect_to @expected_event, notice: 'Expected event was successfully updated' }
  			format.json { head :no_content }
  		else
  			format.html { render action: 'edit' }
  			format.json { render json: @expected_event.errors, status: :unprocessable_entry }
  		end
  	end
  end

  # DELETE /expected_events/1
  # DELETE /expected_events/1.json
  def destroy
  	@expected_event.destroy
  	respond_to do |format|
  		format.html { redirect_to expected_events_url }
  		format.json { head :no_content }
  	end
  end

	private
   		# Use callbacks to share common setup or constraints between actions.
    	def set_expected_event
      		@expected_event = ExpectedEvent.find(params[:id])
    	end

    	# Never trust parameters from the scary internet, only allow the white list through.
    	def expected_event_params
      		params.require(:expected_event).permit([:title])
    	end

end

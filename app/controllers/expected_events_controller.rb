#This file has a bunch of comments, but we want to leave them in 
#here because they are helpful to us at the moment. 
#These comments can be used to understand all controllers.

class ExpectedEventsController < ApplicationController

  helper_method :sort_column, :sort_direction
  before_action :set_expected_event, only: [:show, :edit, :update, :destroy]
 
  #buttons to show, edit, update and destroy only show up when 
  #someone has entered an expected event. 

  #respond_to :html, :json

  #GET /expected_events
  #GET /expected_events.json
  def index
    @expected_events = ExpectedEvent.includes(:incoming_events).order(sort_column + ' ' + sort_direction)
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
  		else
  			format.html { render action: 'new' }
  		end
  	end
  end

  #PATCH/PUT /expected_events/1
  #PATCH/PUT /expected_events/1.json

  def update
  	respond_to do |format|
  		if @expected_event.update(expected_event_params)
  			format.html { redirect_to @expected_event, notice: 'Expected event was successfully updated' }
  		else
  			format.html { render action: 'edit' }
  		end
  	end
  end

  # DELETE /expected_events/1
  # DELETE /expected_events/1.json
  def destroy
  	@expected_event.destroy
  	respond_to do |format|
  		format.html { redirect_to expected_events_url }
  	end
  end

	private
   		# Use callbacks to share common setup or constraints between actions.
    	def set_expected_event
      		@expected_event = ExpectedEvent.find(params[:id])
    	end

    	# Never trust parameters from the scary internet, only allow the white list through.
    	def expected_event_params
      		params.require(:expected_event).permit([:title, :weekday_0, :weekday_1, :weekday_2, :weekday_3, :weekday_4, :weekday_5, :weekday_6])
    	end

      def sort_column
        ExpectedEvent.column_names.include?(params[:sort]) ? params[:sort] : "title"
      end

      def sort_direction
        %w[asc desc]. include?(params[:direction]) ? params[:direction] : "asc"
      end

end

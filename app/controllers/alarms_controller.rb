class AlarmsController < ApplicationController

  before_action :set_expected_event
  before_action :set_alarm, only: [:show, :edit, :update, :destroy]

  #buttons to show, edit, update and destroy only show up when 
  #someone has entered an expected event. 

  respond_to :html, :json

  def index
    @alarms = @expected_event.alarms
    #@alarm_triggers = AlarmTrigger.find(params[:expected_event_id])
    #@expected_event_names
  	#@alarm_triggers = AlarmTrigger.order('title asc').all
    #respond_with @alarm_triggers
  end

  
  def show
  end

  def new
  	@alarm = Alarm.new
    respond_with @expected_event_names
  end

  def edit
    respond_with @expected_event_names
  end

  def create
    @alarm = @expected_event.alarms.build(alarm_params)

  	respond_to do |format|
  		if @alarm.save
  			format.html { redirect_to expected_event_alarm_path(@expected_event, @alarm), notice: 'Alarm was successfully created'}
  			format.json { render action: 'show', status: :created, location: @alarm }
  		else
  			format.html { render action: 'new' }
  			format.json { render json: @alarm.errors, status: :unprocessable_entry }
  		end
  	end
  end


  def update
  	respond_to do |format|
  		if @alarm.update(alarm_params)
  			format.html { redirect_to expected_event_alarm_path(@expected_event, @alarm), notice: 'Alarm was successfully updated' }
  			format.json { head :no_content }
  		else
  			format.html { render action: 'edit' }
  			format.json { render json: @alarm.errors, status: :unprocessable_entry }
  		end
  	end
  end

 
  def destroy
  	@alarm.destroy
  	respond_to do |format|
  		format.html { redirect_to alarms_url }
  		format.json { head :no_content }
  	end
  end

	protected
   		
    	def set_alarm
      		@alarm = @expected_event.alarms.find(params[:id])
    	end

    	def alarm_params
      		params.require(:alarm).permit([:nature, :action, :title])
    	end

  def set_expected_event
    @expected_event = ExpectedEvent.find(params[:expected_event_id])
  end

end

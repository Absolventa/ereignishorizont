class AlarmTriggersController < ApplicationController
  before_action :set_alarm_trigger, only: [:show, :edit, :update, :destroy]
  #buttons to show, edit, update and destroy only show up when 
  #someone has entered an expected event. 

  def index
  	@alarm_triggers = AlarmTrigger.all
  end
  
  def show
  end

  def new
  	@alarm_trigger = AlarmTrigger.new
  end

  def edit
  end

  def create
  	@alarm_trigger = AlarmTrigger.new(alarm_trigger_params)

  	respond_to do |format|
  		if @alarm_trigger.save
  			format.html { redirect_to @alarm_trigger, notice: 'Alarm Trigger was successfully created'}
  			format.json { render action: 'show', status: :created, location: @alarm_trigger }
  		else
  			format.html { render action: 'new' }
  			format.json { render json: @alarm_trigger.errors, status: :unprocessable_entry }
  		end
  	end
  end


  def update
  	respond_to do |format|
  		if @alarm_trigger.update(alarm_trigger_params)
  			format.html { redirect_to @alarm_trigger, notice: 'Alarm Trigger was successfully updated' }
  			format.json { head :no_content }
  		else
  			format.html { render action: 'edit' }
  			format.json { render json: @alarm_trigger.errors, status: :unprocessable_entry }
  		end
  	end
  end

 
  def destroy
  	@alarm_trigger.destroy
  	respond_to do |format|
  		format.html { redirect_to alarm_triggers_url }
  		format.json { head :no_content }
  	end
  end

	private
   		
    	def set_alarm_trigger
      		@alarm_trigger = AlarmTrigger.find(params[:id])
    	end

    	def alarm_trigger_params
      		params.require(:alarm_trigger).permit([:title, :nature, :action])
    	end

end

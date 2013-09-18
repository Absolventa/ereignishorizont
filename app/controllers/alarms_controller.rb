class AlarmsController < ApplicationController

  helper_method :sort_column, :sort_direction
  before_action :set_expected_event
  before_action :set_alarm, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @alarms = @expected_event.alarms.order(sort_column + ' ' + sort_direction)
  end


  def show
  end

  def new
  	@alarm = Alarm.new
  end

  def edit
  end

  def run #this is for email/logger purposes!!!
    @alarm = Alarm.find(params[:id])
    @alarm.run
    if @alarm.enters_email? or @alarm.enters_logger?
      flash[:notice] = "Alarm test successful"
    else
      flash[:error] = "Alarm test failed"
    end
     redirect_to expected_event_alarms_path(@expected_event)
  end

  def create
    @alarm = @expected_event.alarms.build(alarm_params)
  	respond_to do |format|
  		if @alarm.save
  			format.html { redirect_to expected_event_alarm_path(@expected_event, @alarm), notice: 'Alarm was successfully created'}
  		else
  			format.html { render action: 'new' }
  		end
  	end
  end

  def update
  	respond_to do |format|
  		if @alarm.update(alarm_params)
  			format.html { redirect_to expected_event_alarm_path(@expected_event, @alarm), notice: 'Alarm was successfully updated' }
  		else
  			format.html { render action: 'edit' }
  		end
  	end
  end

  def destroy
  	@alarm.destroy
  	respond_to do |format|
  		format.html { redirect_to expected_event_alarms_url }
  	end
  end

	protected

    	def set_alarm
      		@alarm = @expected_event.alarms.find(params[:id])
    	end

    	def alarm_params
      		params.require(:alarm).permit([:action, :title, :recipient_email, :message])
    	end

      def set_expected_event
          @expected_event = ExpectedEvent.find(params[:expected_event_id])
      end

      def sort_column
        Alarm.column_names.include?(params[:sort]) ? params[:sort] : "title"
      end

      def sort_direction
        %w[asc desc]. include?(params[:direction]) ? params[:direction] : "asc"
      end

end

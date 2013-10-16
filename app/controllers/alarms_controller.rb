class AlarmsController < ApplicationController

  helper_method :alarms, :sort_column, :sort_direction
  before_action :set_alarm, only: [:show, :edit, :update, :destroyi, :run]

  respond_to :html

  def index
  end

  def show
  end

  def new
    @alarm = Alarm.new
  end

  def edit
  end

  def run
    event = ExpectedEvent.new(title: 'Tested using a bogus event expectation')
    @alarm.run event
    if @alarm.enters_email? or @alarm.enters_logger?
      flash[:notice] = "Alarm test successful"
    else
      flash[:error] = "Alarm test failed"
    end
     redirect_to alarms_path
  end

  def create
    @alarm = Alarm.new(alarm_params)
    @alarm.recipient_email = nil unless @alarm.action == 'Email'
    respond_to do |format|
      if @alarm.save
        format.html { redirect_to alarm_path(@alarm), notice: 'Alarm was successfully created'}
      else
        format.html { render action: 'new' }
      end
    end
  end

  def update
    respond_to do |format|
      if @alarm.update(alarm_params)
        format.html { redirect_to alarm_path(@alarm), notice: 'Alarm was successfully updated' }
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
    @alarm = Alarm.find(params[:id])
  end

  def alarm_params
    params.require(:alarm).permit([:action, :title, :recipient_email, :message])
  end

  def sort_column
    Alarm.column_names.include?(params[:sort]) ? params[:sort] : "alarms.title"
  end

  def sort_direction
    %w[asc desc]. include?(params[:direction]) ? params[:direction] : "asc"
  end

  def alarms
    @alarms ||= begin
                  scope = Alarm.order(sort_column + ' ' + sort_direction)
                  if params[:expected_event_id]
                    scope = scope.includes(:expected_events).where('expected_events.id' => params[:expected_event_id])
                  end
                  scope.page(params[:page]).per_page(10)
                end
  end

end

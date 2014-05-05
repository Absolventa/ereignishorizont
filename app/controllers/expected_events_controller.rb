class ExpectedEventsController < ApplicationController

  include SearchesByTitle

  helper_method :sort_column, :sort_direction
  before_action :set_expected_event, only: [:show, :edit, :update, :destroy]

  def index
  end

  def show
  end

  def new
    @expected_event = ExpectedEvent.new(matching_direction: false)
  end

  def edit
  end

  def create
    @expected_event = ExpectedEvent.new(expected_event_params)

    respond_to do |format|
      if @expected_event.save
        format.html { redirect_to @expected_event, notice: 'Expected event was successfully created'}
      else
        format.html { render action: 'new' }
      end
    end
  end

  def update
    respond_to do |format|
      if @expected_event.update(expected_event_params)
        format.html { redirect_to @expected_event, notice: 'Expected event was successfully updated' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    @expected_event.destroy
    respond_to do |format|
      format.html { redirect_to expected_events_url }
    end
  end

  private

  def set_expected_event
    @expected_event = ExpectedEvent.find(params[:id])
  end

  def expected_event_params
    params.require(:expected_event).permit(:title, :weekday_0, :weekday_1, :weekday_2,
      :weekday_3, :weekday_4, :weekday_5, :weekday_6, :day_of_month,
      :matching_direction, :started_at, :ended_at, :date_select,
      :final_hour, :remote_side_id, "alarm_ids" => [])
  end

  def sort_column
    ExpectedEvent.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end

  def sort_direction
    %w[asc desc]. include?(params[:direction]) ? params[:direction] : "DESC"
  end

end

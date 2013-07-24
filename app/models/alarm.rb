class Alarm < ActiveRecord::Base
  validates :nature, :expected_event, presence: true
  belongs_to :expected_event

  def run
    ## Do stuff based on my nature
    if action == 'email'
    	AlarmMailer.alarm_email(alarm).deliver
    #else
    	#redirect_to expected_event_alarm_path
  end


end
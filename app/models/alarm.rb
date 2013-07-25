class Alarm < ActiveRecord::Base
  validates :expected_event, presence: true
  belongs_to :expected_event

  validates_presence_of :recipient_email, :if => :enters_email?

  def enters_email?
  	action == 'Email'
  end

  def run
    ## Do stuff based on my action
    #if action == 'email'
    	#AlarmMailer.alarm_email(alarm).deliver
    #else
    	#redirect_to expected_event_alarm_path
  end


end
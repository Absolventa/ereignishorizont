class Alarm < ActiveRecord::Base
  validates :expected_event, presence: true
  belongs_to :expected_event

  validates :recipient_email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, on: :create },
                              presence: true,
                              if: :enters_email?
  

  def enters_email?
    action == 'Email'
  end

  def enters_logger
    action == 'Logger'
  end

  
  def run
    ## Do stuff based on my action
    #if action == 'email'
    	#AlarmMailer.alarm_email(alarm).deliver
    #else
    	#redirect_to expected_event_alarm_path
  end


end
class Alarm < ActiveRecord::Base
  validates :expected_event, presence: true
  belongs_to :expected_event

  validates_presence_of :recipient_email, :if => :enters_email?
  #validates_exclusion_of :recipient_email, :in => :enters_logger,
                          #:message => "Why are you putting in your email? This is for logs!"

  def enters_email?
  	action == 'Email'
  end

  #def enters_logger
    #action == 'Logger'
  #end

  def run
    ## Do stuff based on my action
    #if action == 'email'
    	#AlarmMailer.alarm_email(alarm).deliver
    #else
    	#redirect_to expected_event_alarm_path
  end


end
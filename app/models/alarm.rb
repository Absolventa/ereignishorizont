class Alarm < ActiveRecord::Base
  validates :expected_event, presence: true
  belongs_to :expected_event

  validates :recipient_email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, on: :create },
                              presence: true,
                              if: :enters_email?

 validates_inclusion_of :action, in: %w( Email Logger)
    #we're not entirely sure if this is working/is correct. Do we have to 
    #do something in the browser/try to change it in the browser to see if
    #it is secure against external hacks? HELP!

  def enters_email?
    action == 'Email'
  end

  def enters_logger?
    action == 'Logger'
  end


  def run
    ## Do stuff based on my action
    #if action == 'email'
    	#AlarmMailer.alarm_email(alarm).deliver
  end


end
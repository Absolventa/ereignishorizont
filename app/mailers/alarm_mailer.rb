class AlarmMailer < ActionMailer::Base
  default from: "from@example.com"

  def event_expectation_matched(alarm)
  	@alarm = alarm
  	mail(:to => alarm.recipient_email, :subject => "Don't be alarmed!")
  	#tam playing around
  end
end

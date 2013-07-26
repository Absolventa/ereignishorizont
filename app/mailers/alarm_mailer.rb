class AlarmMailer < ActionMailer::Base
  default from: "susanne_and_tam@awesome.de"

  def event_expectation_matched(alarm)
  	@alarm = alarm
  	@expected_event = alarm.expected_event.title
  	@message = alarm.message
  	mail(:to => alarm.recipient_email, :subject => "Don't be alarmed!")
  	#mail call should always be at the end
  end
end

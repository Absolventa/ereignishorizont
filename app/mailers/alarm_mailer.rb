class AlarmMailer < ActionMailer::Base
  default from: APP_CONFIG[:mail_from]

  def event_expectation_matched(alarm)
    @alarm = alarm
    @expected_event = alarm.expected_event.title
    @message = alarm.message
    mail(:to => alarm.recipient_email, :subject => "Don't be alarmed!")
    #mail call should always be at the end
  end
end

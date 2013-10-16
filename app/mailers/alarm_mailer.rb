class AlarmMailer < ActionMailer::Base
  default from: APP_CONFIG[:mail_from]

  def event_expectation_matched(alarm, expected_event)
    @alarm = alarm
    @expected_event = expected_event.title
    @message = alarm.message
    @matched = expected_event.event_matching_direction_for_email
    subject = "#{@alarm.title}: #{@expected_event}"
    mail(to: alarm.recipient_email, subject: subject)
  end
end

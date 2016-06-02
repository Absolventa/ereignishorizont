class AlarmMailer < ActionMailer::Base
  default from: APP_CONFIG[:mail_from]

  def event_expectation_matched(alarm, expected_event)
    @alarm = alarm
    @expected_event = expected_event
    @remote_side = expected_event.remote_side.try(:name)
    @message = alarm.message
    @matched = expected_event.event_matching_direction_for_email
    subject_infix = [@remote_side, @alarm.title].compact.join(' - ')
    subject = "[ereignishorizont] #{subject_infix}: #{expected_event.title}"
    mail(to: alarm.email_recipient, subject: subject)
  end
end

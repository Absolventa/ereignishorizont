class AlarmMailer < ActionMailer::Base
  default from: APP_CONFIG[:mail_from]

  def event_expectation_matched(alarm, expected_event)
    @alarm = alarm
    @expected_event = expected_event
    @remote_side = expected_event.remote_side.try(:name)
    @message = alarm.message
    @matched = expected_event.event_matching_direction_for_email
    subject_suffix = [@remote_side, @alarm.title].compact.join(' - ')
    subject = "[event_girl] #{subject_suffix}"
    mail(to: alarm.recipient_email, subject: subject)
  end
end

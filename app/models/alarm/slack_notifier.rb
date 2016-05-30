class Alarm::SlackNotifier
  delegate :title, to: :alarm

  attr_reader :alarm, :expected_event, :notifier

  def initialize(alarm, expected_event)
    @alarm, @expected_event = alarm, expected_event
    @notifier = Slack::Notifier.new endpoint, username: 'Ereignishorizont', channel: channel
  end

  def endpoint
    alarm.slack_url
  end

  def channel
    alarm.slack_channel
  end

  def call
    notifier.ping(*payload)
  end

  def message
    if expected_event.matching_direction == 'forward'
      message_for_caught_event
    else
      message_for_missed_event
    end
  end

  def message_for_missed_event
    <<-EOMSG
Your expected event *#{expected_event.title}* did not register before the set deadline #{expected_event.deadline.getlocal}.
EOMSG
  end

  def message_for_caught_event
    <<-EOMSG
Your alert on the event *#{expected_event.title}* has just been registered.
EOMSG
  end

  private

  def payload
    ['', { attachments: attachment_data, icon_url: 'http://railsgirls.com/images/railsgirls-sq.png'} ]
  end

  def attachment_data
    [{
      text: message,
      color: 'warning',
      mrkdwn_in: %w(text)
    }]
  end
end

class Alarm::SlackNotifier
  delegate :title, to: :alarm

  attr_reader :alarm, :notifier

  def initialize(alarm)
    @alarm = alarm
    @notifier = ::Slack::Notifier.new endpoint, username: 'Event Girl'
  end

  def endpoint
    alarm.slack_url
  end

  def call
    notifier.ping(*payload)
  end

  private

  def payload
    ['', { attachments: attachment_data, icon_url: 'http://railsgirls.com/images/railsgirls-sq.png'} ]
  end

  def attachment_data
    [{
      text: title,
      color: 'warning',
      mrkdwn_in: %w(text)
    }]
  end
end

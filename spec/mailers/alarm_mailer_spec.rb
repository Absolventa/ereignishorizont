require "spec_helper"

describe AlarmMailer, :type => :mailer do
  describe '.event_expectation_matched' do
    it 'sends a mail for an alarm' do
      alarm = FactoryGirl.build(:alarm)
      event = FactoryGirl.build(:expected_event)
      mailer = described_class.event_expectation_matched(alarm, event)
      expect do
        mailer.deliver_now
      end.to change { ActionMailer::Base.deliveries.size }.by(1)
      mail = ActionMailer::Base.deliveries.last
      expect(mail.subject).to eql "[event_girl] #{event.remote_side.name} - #{alarm.title}: #{event.title}"
      expect(mail.from).to eql [APP_CONFIG[:mail_from]]
      expect(mail.to).to eql [alarm.recipient_email]
    end
  end
end

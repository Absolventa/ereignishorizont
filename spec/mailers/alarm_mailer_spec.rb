require "spec_helper"

describe AlarmMailer do
  describe '.event_expectation_matched' do
    it 'sends a mail for an alarm' do
      alarm = FactoryGirl.build(:alarm)
      mailer = described_class.event_expectation_matched(alarm)
      expect do
        mailer.deliver
      end.to change { ActionMailer::Base.deliveries.size }.by(1)
      mail = ActionMailer::Base.deliveries.last
      expect(mail.subject).to eql "Don't be alarmed!"
      expect(mail.from).to eql [APP_CONFIG[:mail_from]]
      expect(mail.to).to eql [alarm.recipient_email]
    end
  end
end

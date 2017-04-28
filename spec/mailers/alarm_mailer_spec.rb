require "rails_helper"

RSpec.describe AlarmMailer, type: :mailer do
  describe '.event_expectation_matched' do
    let(:event)     { FactoryGirl.build_stubbed(:expected_event) }
    let(:alarm)     { FactoryGirl.build_stubbed(:alarm) }
    let(:last_mail) { ActionMailer::Base.deliveries.last }

    subject { described_class.event_expectation_matched(alarm, event) }

    it 'sends a mail for an alarm' do
      expect { subject.deliver_now }.to \
        change { ActionMailer::Base.deliveries.size }.by(1)

      expect(last_mail.subject).to eql "[ereignishorizont] #{event.remote_side.name} - #{alarm.title}: #{event.title}"
      expect(last_mail.from).to eql [APP_CONFIG[:mail_from]]
      expect(last_mail.to).to eql [alarm.email_recipient]
    end
  end
end

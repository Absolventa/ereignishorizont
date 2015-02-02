require 'spec_helper'

describe Alarm, :type => :model do

  context "Validations" do

    it { is_expected.to have_many(:alarm_mappings).dependent(:destroy) }
    it { is_expected.to have_many(:expected_events).through :alarm_mappings}
    it { is_expected.to allow_value("a@b.com").for(:email_recipient) }

    it "has a valid factory" do
      expect(FactoryGirl.build(:alarm)).to be_valid
    end

    context 'as a webhook' do
      before { subject.action = 'webhook' }

      it { is_expected.to validate_presence_of :webhook_url }
    end

    context 'with slack' do
      before { subject.action = 'slack' }

      it { is_expected.to validate_presence_of :slack_channel }
      it { is_expected.to validate_presence_of :slack_url }
    end
  end

  describe '#kind' do
    shared_examples_for 'action predicate' do |action|
      let(:predicate) { "be_#{action.downcase}" }

      it { is_expected.to allow_value(action).for(:action) }

      describe "#kind.#{action}?" do
        it "returns true for matching action" do
          subject.action = action
          expect(subject.kind).to send(predicate)
        end

        it "returns false" do
          subject.action = Alarm::ACTIONS.select{|a| a != action}.sample
          expect(subject.kind).not_to send(predicate)
        end
      end
    end

    it_behaves_like 'action predicate', 'logger'
    it_behaves_like 'action predicate', 'email'
    it_behaves_like 'action predicate', 'webhook'
    it_behaves_like 'action predicate', 'slack'
  end

  context "#run" do
    let(:expected_event) { FactoryGirl.build(:expected_event) }

    it 'requires an expected_event as argument' do
      expect(subject.method(:run).arity).to eql 1
    end

    it 'sends an email when email is selected' do
      subject = FactoryGirl.create(:alarm)
      subject.action = 'email'
      expect { subject.run expected_event }.to \
        change { ActionMailer::Base.deliveries.size }.by(1)
    end

    it 'sends a logger message when logger is selected' do
      expect(Rails.logger).to receive(:info)
      subject.action = 'logger'
      subject.run expected_event
    end

    context 'with slack' do
      before do
        subject.assign_attributes FactoryGirl.attributes_for(:alarm, :slack)
        stub_request(:post, subject.slack_url)
      end

      it 'sends payload to slack' do
        subject.run expected_event
        expect(a_request(:post, subject.slack_url)).to have_been_made
      end
    end
  end
end

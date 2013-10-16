require 'spec_helper'

describe Alarm do

  context "Validations" do

    it { should have_many(:alarm_mappings).dependent(:destroy) }
    it { should have_many(:expected_events).through :alarm_mappings}
  	it { should allow_value("a@b.com").for(:recipient_email) }

    it "has a valid factory" do
      FactoryGirl.build(:alarm).should be_valid
    end

    it 'allows available values from the constant' do
      Alarm::ACTIONS.each do |v|
        should allow_value(v).for(:action)
      end
    end

    it 'does not allow other values than those in the constant' do
      Alarm::ACTIONS.each do |v|
        should_not allow_value("other").for(:action)
      end
    end
  end

  context "the dropdown menu" do
    it 'assigns the value "Email" to action if Email is chosen' do
      subject.action = "Email"
      expect(subject.enters_email?).to be_true
    end

    it 'does not assign the value "Email" to action if Email is not chosen' do
      subject.action = "Logger"
      expect(subject.enters_logger?).to be_true
    end

    it 'assigns the value "Logger" to action if Logger is chosen' do
      subject.action = "Logger"
      expect(subject.enters_logger?).to be_true
    end

    it 'does not assigns the value "Logger" to action if Logger is not chosen' do
      subject.action = "Email"
      expect(subject.enters_email?).to be_true
    end
  end

  context "#run" do
    let(:expected_event) { FactoryGirl.build(:expected_event) }

    it 'requires an expected_event as argument' do
      expect(subject.method(:run).arity).to eql 1
    end

    it 'sends an email when email is selected' do
      subject = FactoryGirl.build(:alarm)
      subject.stub(:enters_email?).and_return(true)
      expect do
        subject.run expected_event
      end.to change { ActionMailer::Base.deliveries.size }.by(1)
    end

    it 'sends a logger message when logger is selected' do
      Rails.logger.should_receive(:info)
      subject.stub(:enters_logger?).and_return(true)
      subject.run expected_event
    end
  end
end

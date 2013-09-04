require 'spec_helper'

describe Alarm do

  context "Validations" do
    it { should belong_to :expected_event }
    it { should validate_presence_of :expected_event }
  	it { should allow_value("a@b.com").for(:recipient_email) }
    
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
      expect(subject.action).to eql "Email"
    end

    it 'does not assigns the value "Email" to action if Email is not chosen' do
      subject.action = "Logger"
      expect(subject.action).not_to eql "Email"
    end

    it 'assigns the value "Logger" to action if Logger is chosen' do
      subject.action = "Logger"
      expect(subject.action).to eql "Logger"
    end

    it 'does not assigns the value "Logger" to action if Logger is not chosen' do
      subject.action = "Email"
      expect(subject.action).not_to eql "Logger"
    end
  end

  context "#run" do
    it 'sends an email alarm if Email chosen' do
      subject.action = "Email"
      pending
    end
  end

end
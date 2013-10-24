require 'spec_helper'

describe RemoteSide do

  it { should have_many(:alarm_notifications).dependent(:nullify) }
  it { should have_many(:expected_events).dependent(:nullify) }
  it { should have_many(:incoming_events).dependent(:nullify) }
  it { should validate_presence_of :name }
  it { should validate_uniqueness_of :name }

  it "has a valid factory" do
    FactoryGirl.build(:remote_side).should be_valid
  end

  it 'generates an API token before validation' do
    subject.valid?
    expect(subject.api_token).not_to be_blank
  end

  it 'does not update an API token for an old record' do
    remote_side = FactoryGirl.create(:remote_side)
    expect do
      remote_side.save
    end.not_to change { remote_side.reload.api_token }
  end

  it 'does not create duplicate API tokens' do
    existing = FactoryGirl.create(:remote_side)
    existing.update(api_token: 'abc')

    SecureRandom.stub(:hex).and_return('abc', 'def')
    subject.valid?
    expect(subject.api_token).to eql 'def'
  end
end

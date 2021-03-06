require 'rails_helper'

describe RemoteSide, :type => :model do

  it { is_expected.to have_many(:alarm_notifications).dependent(:nullify) }
  it { is_expected.to have_many(:expected_events).dependent(:nullify) }
  it { is_expected.to have_many(:incoming_events).dependent(:nullify) }
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_uniqueness_of :name }

  it "has a valid factory" do
    expect(FactoryGirl.build(:remote_side)).to be_valid
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

    allow(SecureRandom).to receive(:hex).and_return('abc', 'def')
    subject.valid?
    expect(subject.api_token).to eql 'def'
  end
end

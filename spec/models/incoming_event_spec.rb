require 'spec_helper'

describe IncomingEvent do

  it { should validate_presence_of :title }
  it { should belong_to :expected_event }

  let(:incoming_event) { FactoryGirl.create(:incoming_event) }

  context 'with scopes' do
    describe '.created_today_before' do
      it 'does not return an event from yesterday' do
        Timecop.travel(1.day.ago)
        incoming_event
        Timecop.return
        expect(
          described_class.created_today_before(1.hour.from_now)
        ).not_to include incoming_event
      end

      it 'does not return an event after deadline' do
        incoming_event
        expect(
          described_class.created_today_before(1.hour.ago)
        ).not_to include incoming_event
      end

      it 'returns an event created well before the deadline' do
        incoming_event
        expect(
          described_class.created_today_before(Time.zone.now)
        ).to include incoming_event
      end
    end
  end

  it 'defines its allowed title format' do
    expected = /\A[a-z0-9\s_\.-]+\Z/i
    expect(described_class::FORMAT).to eql expected
  end

  it "has a valid factory" do
    FactoryGirl.build(:incoming_event).should be_valid
  end

  context 'validating title' do
    it 'complains about illegal characters' do
      incoming_event = IncomingEvent.new(title: 'bß€se')
      incoming_event.valid?
      incoming_event.should have(1).error_on(:title)
    end

    it 'removes trailing white spaces before save' do
      incoming_event = IncomingEvent.new(title: ' bose    ')
      incoming_event.save
      incoming_event.title.should == 'bose'
    end
  end

end

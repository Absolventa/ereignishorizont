require 'spec_helper'

describe Matcher do

  let(:expected_event) { FactoryGirl.create(:expected_event) }
  let(:incoming_event) { FactoryGirl.build(:incoming_event) }

  context '#run' do

    it 'tracks a matching Incoming Event' do
      incoming_event.tracked_at = nil
      incoming_event.save

      expected_event = FactoryGirl.build(:active_expected_event)
      expected_event.matching_direction = false
      expected_event = activate_current_weekday_for! expected_event

      subject.stub(:incoming_events_for).and_return([incoming_event])

      subject.run
      expect(incoming_event.reload.tracked_at).not_to be_nil
    end

    it 'sends an alarm if an event is not matched' do
      pending
    end
  end

  context '#expected_events' do
    let(:active_backward_event_for_today) do
      FactoryGirl.build(:active_expected_event).tap do |expected_event|
        activate_current_weekday_for expected_event
      end
    end

    it 'returns an empty list when no expected events are present' do
      expect(subject.expected_events).to be_empty
    end

    it 'includes all active today backward events' do
      active_backward_event_for_today.matching_direction = false
      active_backward_event_for_today.save

      expect(subject.expected_events).to include active_backward_event_for_today
    end

    it 'excludes all active today forward events' do
      active_backward_event_for_today.matching_direction = true
      active_backward_event_for_today.save

      expect(subject.expected_events).not_to include active_backward_event_for_today
    end

  end

  context '#incoming_events_for' do


    it 'finds untracked active incoming event whose title matches' do
      activate_current_weekday_for! expected_event

      incoming_event.tracked_at = nil
      incoming_event.title = expected_event.title
      incoming_event.save

      Timecop.freeze(expected_event.deadline - 15.minutes)

      expect(subject.incoming_events_for(expected_event)).to include incoming_event
    end

  end
end

require 'spec_helper'

describe Matcher do

  subject { described_class }

  let(:expected_event) { FactoryGirl.create(:expected_event) }
  let(:incoming_event) { FactoryGirl.build(:incoming_event) }
  let(:untracked_incoming_event) { FactoryGirl.create(:incoming_event, tracked_at: nil) }

  describe '.run' do

    it 'tracks a matching Incoming Event' do
      expected_event = FactoryGirl.build(:active_expected_event)
      expected_event.matching_direction = false
      expected_event = activate_current_weekday_for! expected_event

      stub_deadline_exceeded! true
      subject.stub(:incoming_events_for).and_return([untracked_incoming_event])

      subject.run
      expect(untracked_incoming_event.reload.tracked_at).not_to be_nil
    end

    it 'sends an alarm if an event is not matched' do
      subject.stub(:incoming_events_for).and_return([])
      subject.stub(:expected_events).and_return([expected_event])

      expected_event.should_receive(:alarm!)
      subject.run
    end

    it 'does not sound an alarm if matching incoming event was detected' do
      Timecop.travel(Time.zone.now.beginning_of_day + 1.hour)

      expected_event = FactoryGirl.build(:active_expected_event)
      expected_event.final_hour = 10
      expected_event.title = untracked_incoming_event.title
      expected_event.matching_direction = false
      activate_current_weekday_for! expected_event

      ExpectedEvent.any_instance.should_not_receive(:alarm!)

      Timecop.travel(Time.zone.now.beginning_of_day + 11.hours)
      subject.run
    end

  end

  describe '.expected_events' do
    let(:active_backward_event_for_today) do
      FactoryGirl.build(:active_expected_event).tap do |expected_event|
        activate_current_weekday_for expected_event
      end
    end

    it 'returns an empty list when no expected events are present' do
      expect(subject.expected_events).to be_empty
    end

    it 'includes all active today backward events whose deadline is exceeded and that have not been alarmed yet' do
      active_backward_event_for_today.matching_direction = false
      active_backward_event_for_today.save
      stub_deadline_exceeded! true

      expect(subject.expected_events).to include active_backward_event_for_today
    end

    it 'excludes all active today forward events' do
      active_backward_event_for_today.matching_direction = true
      active_backward_event_for_today.save

      expect(subject.expected_events).not_to include active_backward_event_for_today
    end

    it 'excludes all active today backward events whose deadline has not been exceeded' do
      active_backward_event_for_today.matching_direction = false
      active_backward_event_for_today.save
      stub_deadline_exceeded! false

      expect(subject.expected_events).not_to include active_backward_event_for_today
    end

    context 'with alarm notification check' do
      it 'excludes events with an alarm notification from today' do
        active_backward_event_for_today.matching_direction = false
        active_backward_event_for_today.save
        FactoryGirl.create(
          :alarm_notification, expected_event: active_backward_event_for_today
        )
        expect(subject.expected_events).not_to include active_backward_event_for_today
      end

      it 'returns an active event that has an alarm notification for yesterday' do
        active_backward_event_for_today.matching_direction = false
        active_backward_event_for_today.save
        stub_deadline_exceeded! true

        Timecop.travel(1.day.ago)
        FactoryGirl.create(
          :alarm_notification, expected_event: active_backward_event_for_today
        )

        Timecop.return
        expect(subject.expected_events).to include active_backward_event_for_today
      end
    end
  end

  describe '.incoming_events_for' do

    it 'finds untracked active incoming event whose title matches' do
      # FIXME Test should be independent of run time
      # This will break when run between 23:01 and midnight
      expected_event.final_hour = Time.zone.now.hour + 1
      activate_current_weekday_for! expected_event

      incoming_event.tracked_at = nil
      incoming_event.title = expected_event.title
      incoming_event.save

      expect(subject.incoming_events_for(expected_event)).to include incoming_event
    end
  end

  def stub_deadline_exceeded! value
    ExpectedEvent.any_instance.stub(:deadline_exceeded?).and_return(value)
  end
end

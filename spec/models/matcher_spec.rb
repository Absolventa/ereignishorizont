require 'spec_helper'

describe Matcher do

  subject { described_class }

  let(:expected_event) { FactoryGirl.create(:expected_event) }
  let(:incoming_event) { FactoryGirl.build(:incoming_event) }
  let(:untracked_incoming_event) { FactoryGirl.create(:incoming_event, tracked_at: nil) }

  let(:active_backward_event_for_today) do
    FactoryGirl.build(:active_expected_event).tap do |expected_event|
      expected_event.matching_direction = false
      activate_current_weekday_for expected_event
    end
  end

  describe '.run' do

    it 'tracks a matching Incoming Event' do
      active_backward_event_for_today.save
      stub_deadline_exceeded!
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

      expected_event = active_backward_event_for_today
      expected_event.final_hour = 10
      expected_event.title = untracked_incoming_event.title

      ExpectedEvent.any_instance.should_not_receive(:alarm!)

      Timecop.travel(Time.zone.now.beginning_of_day + 11.hours)
      subject.run
    end

  end

  describe '.expected_events' do
    it 'returns an empty list when no expected events are present' do
      expect(subject.expected_events).to be_empty
    end

    it 'includes all active today backward events whose deadline is exceeded and that have not been alarmed yet' do
      active_backward_event_for_today.save
      stub_deadline_exceeded!

      expect(subject.expected_events).to include active_backward_event_for_today
    end

    it 'excludes all active today forward events' do
      forward_event = active_backward_event_for_today
      forward_event.matching_direction = true
      forward_event.save

      expect(subject.expected_events).not_to include forward_event
    end

    it 'excludes all active today backward events whose deadline has not been exceeded' do
      active_backward_event_for_today.save
      expect(subject.expected_events).not_to include active_backward_event_for_today
    end

    context 'with alarm notification check' do
      it 'excludes events with an alarm notification from today' do
        active_backward_event_for_today.save
        FactoryGirl.create(
          :alarm_notification, expected_event: active_backward_event_for_today
        )
        expect(subject.expected_events).not_to include active_backward_event_for_today
      end

      it 'returns an active event that has an alarm notification for yesterday' do
        active_backward_event_for_today.save
        stub_deadline_exceeded!

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
      active_backward_event_for_today.final_hour = Time.zone.now.hour + 1
      active_backward_event_for_today.save

      incoming_event.tracked_at = nil
      incoming_event.title = active_backward_event_for_today.title
      incoming_event.save

      expect(subject.incoming_events_for(active_backward_event_for_today)).to include incoming_event
    end
  end

  def stub_deadline_exceeded!
    ExpectedEvent.any_instance.stub(:deadline_exceeded?).and_return(true)
  end
end

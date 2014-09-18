require 'spec_helper'

describe Matcher, :type => :model do

  subject { described_class }

  let(:expected_event) { FactoryGirl.create(:active_expected_event) }
  let(:incoming_event) { FactoryGirl.create(:incoming_event) }

  let(:active_backward_event_for_today) do
    expected_event.tap do |expected_event|
      expected_event.matching_direction = 'backward'
      activate_current_weekday_for expected_event
    end
  end

  describe '.run' do

    it 'sends an alarm if an event is not matched' do
      allow(subject).to receive(:incoming_events_for).and_return([])
      allow(subject).to receive(:expected_events).and_return([expected_event])

      expect(expected_event).to receive(:alarm!)
      subject.run
    end

    it 'does not sound an alarm if matching incoming event was detected' do
      Timecop.travel(Time.now.utc.beginning_of_day + 1.hour)

      expected_event = active_backward_event_for_today
      expected_event.final_hour = 10
      expected_event.title = incoming_event.title

      expect_any_instance_of(ExpectedEvent).not_to receive(:alarm!)

      Timecop.travel(Time.now.utc.beginning_of_day + 11.hours)
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
      forward_event.matching_direction = 'forward'
      forward_event.save

      expect(subject.expected_events).not_to include forward_event
    end

    it 'excludes all active today backward events whose deadline has not been exceeded' do
      active_backward_event_for_today.save
      expect(subject.expected_events).not_to include active_backward_event_for_today
    end

    context 'with alarm notification check' do
      before { stub_deadline_exceeded! }

      it 'excludes events with an alarm notification from today' do
        active_backward_event_for_today.save
        create_alarm_notification_for active_backward_event_for_today
        expect(subject.expected_events).not_to include active_backward_event_for_today
      end

      it 'includes events with an alarm notification for a different remote side' do
        active_backward_event_for_today.save
        create_alarm_notification_for(active_backward_event_for_today, FactoryGirl.create(:remote_side))
        expect(subject.expected_events).to include active_backward_event_for_today
      end

      it 'returns an active event that has an alarm notification for yesterday' do
        active_backward_event_for_today.save

        Timecop.travel(1.day.ago) do
          create_alarm_notification_for active_backward_event_for_today
        end

        expect(subject.expected_events).to include active_backward_event_for_today
      end

      context 'with monthly event expectations' do
        it 'finds a monthly event with day of month being spot on the current day' do
          expected_event.matching_direction = 'backward'
          expected_event.day_of_month = Date.today.day
          expected_event.save
          expect(subject.expected_events).to eql [expected_event]
        end
      end

      def create_alarm_notification_for event, remote_side = nil
        remote_side ||= event.remote_side
        FactoryGirl.create(:alarm_notification, expected_event: event, remote_side: remote_side)
      end
    end
  end

  describe '.incoming_events_for' do

    it 'finds active incoming event whose title matches' do
      # FIXME Test should be independent of run time
      # This will break when run between 23:01 and midnight
      active_backward_event_for_today.final_hour = Time.now.utc.hour + 1
      active_backward_event_for_today.save

      incoming_event.title = active_backward_event_for_today.title
      incoming_event.remote_side = active_backward_event_for_today.remote_side
      incoming_event.save

      expect(subject.incoming_events_for(active_backward_event_for_today)).to include incoming_event
    end

    it "finds only incoming events matching the expected event's remote side" do
      active_backward_event_for_today.final_hour = Time.now.utc.hour + 1
      active_backward_event_for_today.save

      incoming_event.title = active_backward_event_for_today.title
      incoming_event.remote_side = FactoryGirl.create(:remote_side)
      incoming_event.save

      expect(subject.incoming_events_for(active_backward_event_for_today)).not_to include incoming_event
    end
  end

  def stub_deadline_exceeded!
    allow_any_instance_of(ExpectedEvent).to receive(:deadline_exceeded?).and_return(true)
  end
end

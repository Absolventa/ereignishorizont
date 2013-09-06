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

    it 'sends an Alarm if an Event is not matched' do
      pending
    end
  end

  context '#expected_events' do
    let(:active_event) { FactoryGirl.build(:active_expected_event) }
    it 'includes all active today backward events' do
      active_event.update_attribute("weekday_#{Date.today.wday}".to_sym, true)
      active_event.matching_direction = false
      active_event.save

      expect(subject.expected_events.find_by_id(active_event.id)).to be_present
    end

    it 'excludes all active today forward events' do
      active_event.update_attribute("weekday_#{Date.today.wday}".to_sym, true)
      active_event.matching_direction = true
      active_event.save

      expect(subject.expected_events.find_by_id(active_event.id)).not_to be_present
    end

    it 'delivers empty relation when no expected_event is present' do
     pending
    end

    it 'checks that an Expected Event is checked for today' do
      pending
    end

    it 'checks that an Expected Event is set to backward' do
      pending
    end

    it 'checks for an Expected Event' do
      pending
    end
  end

  context '#incoming_events_for' do
    it 'only considers Incoming Events that have not been tracked' do
      pending
    end

    it 'only considers Incoming Events that have the same title as Expected Event' do
      pending
    end

    it 'only considers Incoming Events that have been created today' do
      pending
    end

    it 'only considers Incoming events that have been created before the deadline' do
      pending
    end
  end
end

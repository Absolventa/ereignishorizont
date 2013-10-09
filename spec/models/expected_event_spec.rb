require 'spec_helper'

describe ExpectedEvent do

  it { should have_many(:alarms).dependent(:destroy) }
  it { should have_many(:alarm_notifications).dependent(:destroy) }
  it { should have_many :incoming_events }
  it { should validate_presence_of :title }
  #it { should ensure_inclusion_of(:matching_direction).in_array([true false]) }
  # seems to be a shoulda bug, does not work
  it { should ensure_inclusion_of(:final_hour).in_range(1..24) }

  it { should allow_value(true).for(:matching_direction) }
  it { should allow_value(false).for(:matching_direction) }
  it { should_not allow_value(nil).for(:matching_direction) }

  it "has a valid factory" do
    FactoryGirl.build(:expected_event).should be_valid
  end

  context 'validating title' do
    it 'complains about illegal characters' do
      expected_event = ExpectedEvent.new(title: 'bß€se')
      expected_event.valid?
      expected_event.should have(1).error_on(:title)
    end

    it 'removes trailing white spaces before save' do
      expected_event = ExpectedEvent.new(title: ' bose    ')
      expected_event.save
      expected_event.title.should == 'bose'
    end
  end

  describe "#active?" do
    it 'returns true if current time is between start date and end date' do
      subject.started_at = 1.day.ago
      subject.ended_at 	 = 1.day.from_now
      expect(subject).to be_active  # expect(subject).to be_active oder expect(subject.active?).to eql true
    end

    it 'returns false if current time is before start date' do
      subject.started_at = 1.day.from_now
      subject.ended_at = 2.days.from_now # ended_at was nil before we added it here, test failed
      expect(subject).not_to be_active
    end

    it 'returns false if current time is after end date' do
      subject.started_at = 2.days.ago
      subject.ended_at = 1.day.ago
      expect(subject).not_to be_active
    end

    it 'returns true if both start and end date are set to today' do
      subject.started_at = Date.today
      subject.ended_at = Date.today
      expect(subject).to be_active
    end

    context 'with open end date' do
      it 'returns true if neither start not end is set' do
        subject.started_at = nil
        subject.ended_at = nil
        expect(subject).to be_active
      end

      it 'returns true if current date is after start date' do
        subject.started_at = 1.day.ago
        subject.ended_at = nil
        expect(subject).to be_active
      end

      it 'returns false if current date is before start date' do
        subject.started_at = 1.day.from_now
        subject.ended_at = nil
        expect(subject).not_to be_active
      end
    end

    it 'handles semantically wrong input' do
      subject.started_at = nil
      subject.ended_at = 1.day.from_now
      expect(subject).not_to be_active
    end

  end

  describe "#event_matching_direction" do
    it 'returns "when found" if true' do
      subject.matching_direction = true
      expect(subject.event_matching_direction).to eql "when found"
    end

    it 'returns "when not found" if false' do
      subject.matching_direction = false
      expect(subject.event_matching_direction).to eql "when not found"
    end
  end

  describe "#activity_status" do
    it 'returns "active" if event is ongoing' do
      subject.stub(active?: true) # alternative syntax
      expect(subject.activity_status).to eql "active"
    end

    it 'returns "inactive" if event is not ongoing' do
      subject.stub(:active?).and_return(false)
      expect(subject.activity_status).to eql "inactive"
    end
  end

  describe '#alarm!' do
    it 'does nothing when no alarms exist' do
      Alarm.any_instance.should_not_receive(:run)
      subject.alarm!
    end

    it 'calls the run method on each alarm' do
      alarm = Alarm.new
      alarm.should_receive(:run)
      subject.alarms = [alarm]
      subject.alarm!
    end

    it 'creates an AlarmNotification' do
      subject = FactoryGirl.create(:expected_event)
      expect do
        subject.alarm!
      end.to change { AlarmNotification.count }.by(1)
      alarm_notification = AlarmNotification.last
      expect(alarm_notification.expected_event).to eql subject
    end
  end

  describe '#weekdays' do
    it 'returns a list of seven false values' do
      expect(subject.weekdays).to eql [false, false, false, false, false, false, false]
    end

    it 'returns a boolean value for each weekday' do
      subject.weekday_1 = true
      subject.weekday_6 = true
      expect(subject.weekdays).to eql [false, true, false, false, false, false, true]
    end
  end

  describe '#deadline' do
    context 'with current weekday activated' do
      it 'returns a datetime representing today at noon' do
        expected_date = Time.zone.now.beginning_of_day + 12.hours
        subject.final_hour = 12
        subject.weekday_0 = true
        subject.weekday_1 = true
        subject.weekday_2 = true
        subject.weekday_3 = true
        subject.weekday_4 = true
        subject.weekday_5 = true
        subject.weekday_6 = true
        expect(subject.deadline).to eql expected_date
      end
    end

    context 'with current weekday deactivated' do
      it 'returns the beginning of the current day' do
        expected_date = Time.zone.now.beginning_of_day
        expect(subject.deadline).to eql expected_date
      end
    end
  end

  describe '#deadline_exceeded?' do
    it 'returns false for all forward expectations' do
      subject.matching_direction = true
      expect(subject.deadline_exceeded?).to eql false
    end

    it 'returns true' do
      subject.stub(:deadline).and_return(1.minute.ago)
      expect(subject.deadline_exceeded?).to eql true
    end

    it 'returns false' do
      subject.stub(:deadline).and_return(1.minute.from_now)
      expect(subject.deadline_exceeded?).to eql false
    end
  end

  describe '#checked_today?' do
    before do
      new_time = Time.local(2013, 8, 28, 12, 0, 0) # That'd be a wednesday
      Timecop.freeze(new_time)
    end

    it 'returns todays true if current weekday selected' do
      subject.weekday_3 = true
      expect(subject).to be_checked_today
    end

    it 'returns false' do
      subject.weekday_3 = false
      expect(subject).not_to be_checked_today
    end
  end

  context 'with scopes' do
    it 'has an active scope' do
      expect(ExpectedEvent.active).to be_kind_of ActiveRecord::Relation
    end

    it 'has a forward scope' do
      expect(ExpectedEvent.forward).to be_kind_of ActiveRecord::Relation
    end

    it 'has a backward scope' do
      expect(ExpectedEvent.backward).to be_kind_of ActiveRecord::Relation
    end

    describe ".scope" do
      it 'has a today scope' do
        expect(ExpectedEvent.today).to be_kind_of ActiveRecord::Relation
      end

      it 'finds an expected event among the today scope' do
        expected_event = FactoryGirl.build(:expected_event)
        expected_event = activate_current_weekday_for! expected_event
        expect(ExpectedEvent.today).to include expected_event
      end
    end
  end
end

require 'spec_helper'

describe ExpectedEvent do
  let(:expected_event) { FactoryGirl.create(:expected_event) }

  it { should have_many(:alarm_mappings).dependent(:destroy) }
  it { should have_many(:alarms).through(:alarm_mappings) }
  it { should have_many(:alarm_notifications).dependent(:destroy) }
  it { should have_many :incoming_events }
  it { should belong_to :remote_side }

  context 'with validations' do
    it { should validate_presence_of :remote_side }
    it { should validate_presence_of :title }
    it { should ensure_inclusion_of(:matching_direction).in_array %w(backward forward) }
    it { should ensure_inclusion_of(:final_hour).in_range(1..24) }

    it { should_not allow_value(nil).for(:matching_direction) }

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

      it 'prevents same title for same remote sides' do
        expected_event = FactoryGirl.create(:expected_event)
        subject.title = expected_event.title
        subject.remote_side = expected_event.remote_side
        subject.valid?
        expect(subject).to have(1).error_on(:title)
      end

      it 'allows same title for different remote sides' do
        expected_event = FactoryGirl.create(:expected_event)
        subject.title = expected_event.title
        subject.remote_side = FactoryGirl.create(:remote_side)
        subject.valid?
        expect(subject).to have(0).errors_on(:title)
      end
    end
  end

  it "has a valid factory" do
    FactoryGirl.build(:expected_event).should be_valid
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
      subject.matching_direction = 'forward'
      expect(subject.event_matching_direction).to eql "when found"
    end

    it 'returns "when not found" if false' do
      subject.matching_direction = 'backward'
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
      allow_any_instance_of(Alarm).to receive(:run).
        and_raise(ArgumentError.new 'Should not be called')
      expect { subject.alarm! }.not_to raise_error
    end

    it 'calls the run method on each alarm' do
      alarm = Alarm.new
      expect(alarm).to receive(:run).and_call_original
      subject.alarms = [alarm]
      subject.alarm!
    end

    it 'creates an AlarmNotification' do
      subject = FactoryGirl.create(:expected_event)
      expect do
        subject.alarm!
      end.to change { AlarmNotification.count }.by(1)
      alarm_notification = AlarmNotification.last
      expect(alarm_notification.remote_side).not_to be_nil
      expect(alarm_notification.remote_side).to eql subject.remote_side
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
      subject.matching_direction = 'forward'
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
    describe '.active' do
      it 'has an active scope' do
        expect(ExpectedEvent.active).to be_kind_of ActiveRecord::Relation
      end

      it 'includes record without start and end dates' do
        expected_event = FactoryGirl.create(:expected_event, started_at: nil, ended_at: nil)
        expect(described_class.active).to include expected_event
      end

      it 'includes record with a start date but without an end date' do
        expected_event = FactoryGirl.create(:expected_event, started_at: 1.day.ago, ended_at: nil)
        expect(described_class.active).to include expected_event
      end
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

  describe '#last_alarm_at' do
    it 'returns nil when no alarm has been sent yet' do
      expect(subject.last_alarm_at).to be_nil
    end

    it 'returns the created_at of the most recent alarm notification' do
      Timecop.freeze
      last_alarm = expected_event.alarm_notifications.create
      # NOTE Travis keeps failing w/o #to_i
      expect(expected_event.last_alarm_at.to_i).to eql last_alarm.created_at.to_i
    end
  end

  describe '#monthly?' do
    it 'returns false if day_of_month is not set' do
      expect(subject.monthly?).to eql false
    end

    it 'returns true if day_of_month is set' do
      subject.day_of_month = 13
      expect(subject.monthly?).to eql true
    end
  end
end

require 'rails_helper'

describe AlarmNotification, :type => :model do
  it { is_expected.to belong_to :expected_event }
  it { is_expected.to belong_to :remote_side }

  let(:alarm_notification) { FactoryGirl.create(:alarm_notification) }

  context 'with validations' do
    it { is_expected.to validate_presence_of :expected_event }

    let(:conflicting_alarm_notification) do
      FactoryGirl.build(
        :alarm_notification, expected_event: alarm_notification.expected_event
      )
    end

    context 'with unique expected event' do
      it 'is unique for an expected_event for a given day' do
        conflicting_alarm_notification.valid?
        expect(conflicting_alarm_notification).to \
          have(1).error_on(:expected_event_id)
      end

      it 'allows the same expected event on different days' do
        Timecop.freeze(1.day.ago)
        alarm_notification # creates a record
        Timecop.return
        expect do
          conflicting_alarm_notification.save
        end.to change { AlarmNotification.count }.by(1)
      end
    end
  end

  it "has a valid factory" do
    expect(FactoryGirl.build(:alarm_notification)).to be_valid
  end

end

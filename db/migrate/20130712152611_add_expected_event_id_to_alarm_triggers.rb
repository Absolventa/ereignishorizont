class AddExpectedEventIdToAlarmTriggers < ActiveRecord::Migration
  def change
    add_column :alarm_triggers, :expected_event_id, :integer
    add_index :alarm_triggers, :expected_event_id
  end
end

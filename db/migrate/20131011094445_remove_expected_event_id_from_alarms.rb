class RemoveExpectedEventIdFromAlarms < ActiveRecord::Migration
  def up
    remove_column :alarms, :expected_event_id
  end

  def down
    change_table :alarms do |t|
      t.references :expected_event, index: true
    end
  end
end

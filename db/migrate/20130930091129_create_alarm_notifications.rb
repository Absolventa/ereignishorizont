class CreateAlarmNotifications < ActiveRecord::Migration
  def change
    create_table :alarm_notifications do |t|
      t.integer :expected_event_id

      t.timestamps
    end

    add_index :alarm_notifications, :expected_event_id
  end
end

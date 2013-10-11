class CreateAlarmMappings < ActiveRecord::Migration
  def change
    create_table :alarm_mappings do |t|
      t.references :alarm, index: true
      t.references :expected_event, index: true

      t.timestamps
    end
  end
end

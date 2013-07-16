class RenameAlarmTriggersTable < ActiveRecord::Migration
  def change
  	rename_table 'alarm_triggers', 'alarms'
  end
end

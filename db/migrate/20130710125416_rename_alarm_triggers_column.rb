class RenameAlarmTriggersColumn < ActiveRecord::Migration
  def change
  	rename_column 'alarm_triggers', 'type', 'nature'
  end
end

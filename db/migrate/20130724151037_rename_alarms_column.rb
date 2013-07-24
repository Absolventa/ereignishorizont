class RenameAlarmsColumn < ActiveRecord::Migration
  def change
  	rename_column 'alarms', 'email', 'recipient_email'
  end
end

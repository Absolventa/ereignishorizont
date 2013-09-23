class AddTimestampsToAlarms < ActiveRecord::Migration
  def change
    change_table :alarms do |t|
      t.timestamps
    end
  end
end

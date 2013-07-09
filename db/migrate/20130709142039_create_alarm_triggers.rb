class CreateAlarmTriggers < ActiveRecord::Migration
  def change
    create_table :alarm_triggers do |t|
      t.string :title
      t.string :type
      t.string :action
    end
  end
end

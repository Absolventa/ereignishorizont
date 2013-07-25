class AddMessageToAlarms < ActiveRecord::Migration
  def change
    add_column :alarms, :message, :text
  end
end

class RemoveNatureFromAlarms < ActiveRecord::Migration
  def change
    remove_column :alarms, :nature, :string
  end
end

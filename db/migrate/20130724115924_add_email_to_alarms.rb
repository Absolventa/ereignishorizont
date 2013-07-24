class AddEmailToAlarms < ActiveRecord::Migration
  def change
    add_column :alarms, :email, :string
  end
end

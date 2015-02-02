class AddActionSpecificAttributesToAlarms < ActiveRecord::Migration
  def change
    rename_column :alarms, :target, :email_recipient
    add_column :alarms, :slack_url, :string
    add_column :alarms, :webhook_url, :string
    add_column :alarms, :webhook_method, :string
    add_column :alarms, :webhook_payload, :json
  end
end

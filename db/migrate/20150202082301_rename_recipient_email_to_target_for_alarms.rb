class RenameRecipientEmailToTargetForAlarms < ActiveRecord::Migration
  def change
    rename_column :alarms, :recipient_email, :target
  end
end

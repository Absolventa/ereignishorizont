class AddTrackedAtToIncomingEvents < ActiveRecord::Migration
  def change
    add_column :incoming_events, :tracked_at, :datetime
  end
end

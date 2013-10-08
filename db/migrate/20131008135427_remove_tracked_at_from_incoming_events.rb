class RemoveTrackedAtFromIncomingEvents < ActiveRecord::Migration
  def up
    remove_column :incoming_events, :tracked_at
  end

  def down
    add_column :incoming_events, :tracked_at, :datetime
  end
end

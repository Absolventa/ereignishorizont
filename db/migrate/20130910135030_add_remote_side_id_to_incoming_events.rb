class AddRemoteSideIdToIncomingEvents < ActiveRecord::Migration
  def change
    add_column :incoming_events, :remote_side_id, :integer
  end
end

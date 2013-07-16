class AddExpectedEventIdToIncomingEvents < ActiveRecord::Migration
  def change
    add_column :incoming_events, :expected_event_id, :integer
    add_index :incoming_events, :expected_event_id
  end
end

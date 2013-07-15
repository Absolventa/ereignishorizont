class RenameIncomingEventsColumn < ActiveRecord::Migration
  def change
  	rename_column 'incoming_events', 'event', 'title'
  end
end

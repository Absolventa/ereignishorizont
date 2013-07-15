class RenameExpectedEventsColumn < ActiveRecord::Migration
  def change
  	rename_column 'expected_events', 'event', 'title'
  end
end

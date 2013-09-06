class RenameForwardColumn < ActiveRecord::Migration
  def change
  	rename_column 'expected_events', 'forward', 'matching_direction'
  end
end

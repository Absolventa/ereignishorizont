class AddMatchingDirectionToExpectedEvents < ActiveRecord::Migration
  def change
    add_column :expected_events, :forward, :boolean
    add_column :expected_events, :backward, :boolean
  end
end

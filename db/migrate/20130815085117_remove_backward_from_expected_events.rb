class RemoveBackwardFromExpectedEvents < ActiveRecord::Migration
  def change
    remove_column :expected_events, :backward, :boolean
  end
end

class AddStartedAtDateToExpectedEvents < ActiveRecord::Migration
  def change
    add_column :expected_events, :started_at, :date
  end
end

class AddEndedAtDateToExpectedEvents < ActiveRecord::Migration
  def change
    add_column :expected_events, :ended_at, :date
  end
end

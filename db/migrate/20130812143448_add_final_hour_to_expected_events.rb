class AddFinalHourToExpectedEvents < ActiveRecord::Migration
  def change
    add_column :expected_events, :final_hour, :integer
  end
end

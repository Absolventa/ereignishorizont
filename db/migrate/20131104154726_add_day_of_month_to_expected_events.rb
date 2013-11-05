class AddDayOfMonthToExpectedEvents < ActiveRecord::Migration
  def change
    add_column :expected_events, :day_of_month, :integer
  end
end

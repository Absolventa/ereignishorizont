class AddWeekdaysToExpectedEvents < ActiveRecord::Migration
  def change
    add_column :expected_events, :weekday_0, :boolean
    add_column :expected_events, :weekday_1, :boolean
    add_column :expected_events, :weekday_2, :boolean
    add_column :expected_events, :weekday_3, :boolean
    add_column :expected_events, :weekday_4, :boolean
    add_column :expected_events, :weekday_5, :boolean
    add_column :expected_events, :weekday_6, :boolean
  end
end

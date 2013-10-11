class ChangeMatchingDirectionToStringForExpectedEvents < ActiveRecord::Migration
  def up
    change_column :expected_events, :matching_direction, :string
    ExpectedEvent.reset_column_information
    ExpectedEvent.where(matching_direction: 'true').update_all("matching_direction = 'forward'")
    ExpectedEvent.where(matching_direction: 'false').update_all("matching_direction = 'backward'")
  end

  def down
    remove_column :expected_events, :matching_direction
    add_column :expected_events, :matching_direction, :boolean
  end
end

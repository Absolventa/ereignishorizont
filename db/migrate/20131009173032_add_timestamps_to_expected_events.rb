class AddTimestampsToExpectedEvents < ActiveRecord::Migration
  def change
    change_table :expected_events do |t|
      t.timestamps
    end
  end
end

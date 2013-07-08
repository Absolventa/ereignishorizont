class CreateExpectedEvents < ActiveRecord::Migration
  def change
    create_table :expected_events do |t|

      t.timestamps
    end
  end
end

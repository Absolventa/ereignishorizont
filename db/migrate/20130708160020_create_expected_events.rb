class CreateExpectedEvents < ActiveRecord::Migration
  def change
    create_table :expected_events do |t|
      t.text :event
    end
  end
end

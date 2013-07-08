class CreateIncomingEvents < ActiveRecord::Migration
  def change
    create_table :incoming_events do |t|
      t.text :event

      t.timestamps
    end
  end
end

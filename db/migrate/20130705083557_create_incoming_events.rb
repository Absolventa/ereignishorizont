class CreateIncomingEvents < ActiveRecord::Migration
  def change
    create_table :incoming_events do |t|

      t.timestamps
    end
  end
end

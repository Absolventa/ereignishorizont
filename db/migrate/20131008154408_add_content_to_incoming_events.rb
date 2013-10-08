class AddContentToIncomingEvents < ActiveRecord::Migration
  def change
    add_column :incoming_events, :content, :text
  end
end

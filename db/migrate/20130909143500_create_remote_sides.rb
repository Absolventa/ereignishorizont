class CreateRemoteSides < ActiveRecord::Migration
  def change
    create_table :remote_sides do |t|
      t.string :title
      t.string :api_token

      t.timestamps
    end
  end
end

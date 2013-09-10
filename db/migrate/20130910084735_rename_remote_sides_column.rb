class RenameRemoteSidesColumn < ActiveRecord::Migration
  def change
    rename_column 'remote_sides', 'title', 'name'
  end
end

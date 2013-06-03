class RenameServerToServerSet < ActiveRecord::Migration
  def up
    rename_table :servers, :server_sets
    rename_column :logs, :server_id, :server_set_id
    rename_column :server_settings, :server_id, :server_set_id
  end

  def down
    rename_table :server_sets, :servers
    rename_column :logs, :server_set_id, :server_id
    rename_column :server_settings, :server_set_id, :server_id
  end
end

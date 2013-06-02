class RenameDbServersToServers < ActiveRecord::Migration
  def up
    rename_table :db_servers, :servers
    remove_column :servers, :state
    remove_column :servers, :sun
    remove_column :servers, :mon
    remove_column :servers, :tue
    remove_column :servers, :wed
    remove_column :servers, :thu
    remove_column :servers, :fri
    remove_column :servers, :sat

    add_column :servers, :server_type, :string
  end

  def down
    remove_column :servers, :server_type

    add_column :servers, :state, :boolean
    add_column :servers, :sun, :boolean
    add_column :servers, :mon, :boolean
    add_column :servers, :tue, :boolean
    add_column :servers, :wed, :boolean
    add_column :servers, :thu, :boolean
    add_column :servers, :fri, :boolean
    add_column :servers, :sat, :boolean

    rename_table :servers, :db_servers
  end
end

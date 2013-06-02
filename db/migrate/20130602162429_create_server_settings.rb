class CreateServerSettings < ActiveRecord::Migration
  def change
    create_table :server_settings do |t|
      t.references :server
      t.string :key
      t.string :value

      t.timestamps
    end
    add_index :server_settings, :server_id
  end
end

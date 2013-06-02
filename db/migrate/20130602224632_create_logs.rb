class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.references :server
      t.string :action
      t.string :source

      t.timestamps
    end
    add_index :logs, :server_id
  end
end

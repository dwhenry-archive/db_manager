class CreateDbServers < ActiveRecord::Migration
  def change
    create_table :db_servers do |t|
      t.string :name
      t.boolean :state
      t.boolean :sun
      t.boolean :mon
      t.boolean :tue
      t.boolean :wed
      t.boolean :thu
      t.boolean :fri
      t.boolean :sat

      t.timestamps
    end
  end
end

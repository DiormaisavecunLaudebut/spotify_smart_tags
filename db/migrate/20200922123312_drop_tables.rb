class DropTables < ActiveRecord::Migration[6.0]
  def up
    drop_table :taggings
    drop_table :tags
  end

  def down
    fail ActiveRecord::IrreversibleMigration
  end
end

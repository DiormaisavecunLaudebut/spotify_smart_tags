class DropTables < ActiveRecord::Migration[6.0]
  def up
    drop_table :taggings
    drop_table :tags
    drop_table :sptags
  end

  def down
    fail ActiveRecord::IrreversibleMigration
  end
end

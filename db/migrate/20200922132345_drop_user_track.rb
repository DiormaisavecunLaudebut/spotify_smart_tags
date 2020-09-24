class DropUserTrack < ActiveRecord::Migration[6.0]
  def up
    drop_table :user_tracks
  end

  def down
    fail ActiveRecord::IrreversibleMigration
  end
end

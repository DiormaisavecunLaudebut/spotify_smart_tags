class DropPlaylistTracks < ActiveRecord::Migration[6.0]
  def up
    drop_table :playlist_tracks
  end

  def down
    fail ActiveRecord::IrreversibleMigration
  end
end

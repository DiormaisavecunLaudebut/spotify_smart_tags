class CreateUserPlaylistTracks < ActiveRecord::Migration[6.0]
  def change
    create_table :user_playlist_tracks do |t|
      t.references :user_track, null: false, foreign_key: true
      t.references :playlist, null: false, foreign_key: true

      t.timestamps
    end
  end
end

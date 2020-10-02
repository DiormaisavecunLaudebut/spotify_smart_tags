class AddSpotifyUpdatePreferencesToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :spotify_update_my_playlists, :boolean, null: false, default: true
    add_column :users, :spotify_update_follow_playlists, :boolean, null: false, default: true
    add_column :users, :spotify_update_albums, :boolean, null: false, default: true
    add_column :users, :spotify_update_liked_songs, :boolean, null: false, default: true
  end
end

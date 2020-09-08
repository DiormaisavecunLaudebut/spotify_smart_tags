class AddCoverUrlToTracklandPlaylist < ActiveRecord::Migration[6.0]
  def change
    add_column :trackland_playlists, :cover_url, :string
  end
end

class AddSpotifyTagsToTracks < ActiveRecord::Migration[6.0]
  def change
    add_column :tracks, :spotify_tags, :string, array: true, default: []
  end
end

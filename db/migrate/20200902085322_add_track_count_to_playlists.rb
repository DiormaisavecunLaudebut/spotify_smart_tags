class AddTrackCountToPlaylists < ActiveRecord::Migration[6.0]
  def change
    add_column :playlists, :track_count, :integer
  end
end

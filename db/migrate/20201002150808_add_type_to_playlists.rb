class AddTypeToPlaylists < ActiveRecord::Migration[6.0]
  def change
    add_column :playlists, :playlist_type, :string, null: false, default: 'playlist'
  end
end

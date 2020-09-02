class AddStuffToPlaylists < ActiveRecord::Migration[6.0]
  def change
    add_column :playlists, :description, :string
    add_column :playlists, :href, :string
    add_column :playlists, :external_url, :string
    add_column :playlists, :spotify_id, :string
  end
end

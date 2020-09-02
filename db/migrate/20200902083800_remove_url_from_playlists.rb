class RemoveUrlFromPlaylists < ActiveRecord::Migration[6.0]
  def change
    remove_column :playlists, :url, :string
  end
end

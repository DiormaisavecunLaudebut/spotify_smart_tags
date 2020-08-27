class AddSpotifyClientToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :spotify_client, :string, null: false
  end
end

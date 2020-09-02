class RemoveNullConstraintForSpotifyClientInUsers < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :spotify_client, :string, null: true
  end
end

class AddExpiresAtToSpotifyTokens < ActiveRecord::Migration[6.0]
  def change
    add_column :spotify_tokens, :expires_at, :datetime, null: false
  end
end

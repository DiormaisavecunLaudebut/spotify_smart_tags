class RemoveExpiresAtFromSpotifyTokens < ActiveRecord::Migration[6.0]
  def change
    remove_column :spotify_tokens, :expires_at, :date
  end
end

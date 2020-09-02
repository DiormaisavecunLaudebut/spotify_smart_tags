class CreateSpotifyTokens < ActiveRecord::Migration[6.0]
  def change
    create_table :spotify_tokens do |t|
      t.string :code
      t.string :refresh_token
      t.date :expires_at
      t.references :user, null: true, foreign_key: true

      t.timestamps
    end
  end
end

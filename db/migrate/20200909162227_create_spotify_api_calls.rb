class CreateSpotifyApiCalls < ActiveRecord::Migration[6.0]
  def change
    create_table :spotify_api_calls do |t|
      t.string :path
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end

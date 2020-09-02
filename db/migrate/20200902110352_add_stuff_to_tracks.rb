class AddStuffToTracks < ActiveRecord::Migration[6.0]
  def change
    add_column :tracks, :href, :string
    add_column :tracks, :duration, :integer
    add_column :tracks, :external_url, :string
    add_column :tracks, :spotify_id, :string
  end
end

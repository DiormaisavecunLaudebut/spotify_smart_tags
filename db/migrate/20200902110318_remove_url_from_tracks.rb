class RemoveUrlFromTracks < ActiveRecord::Migration[6.0]
  def change
    remove_column :tracks, :url, :string
  end
end

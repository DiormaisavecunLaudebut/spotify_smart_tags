class AddIstagToTracks < ActiveRecord::Migration[6.0]
  def change
    add_column :tracks, :is_tag, :boolean, default: false
  end
end

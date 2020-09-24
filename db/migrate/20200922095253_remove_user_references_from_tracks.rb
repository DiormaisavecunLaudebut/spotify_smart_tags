class RemoveUserReferencesFromTracks < ActiveRecord::Migration[6.0]
  def change
    remove_reference :tracks, :user, index: true, foreign_key: true
    remove_column :tracks, :is_tag, :boolean
  end
end

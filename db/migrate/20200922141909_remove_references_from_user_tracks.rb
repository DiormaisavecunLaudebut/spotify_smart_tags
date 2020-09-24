class RemoveReferencesFromUserTracks < ActiveRecord::Migration[6.0]
  def change
    remove_reference :user_tracks, :playlist, index: true, foreign_key: true
    add_reference :user_tracks, :user_tag, index: true, foreign_key: true
  end
end

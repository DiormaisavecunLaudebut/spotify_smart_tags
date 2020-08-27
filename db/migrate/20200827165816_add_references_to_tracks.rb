class AddReferencesToTracks < ActiveRecord::Migration[6.0]
  def change
    add_reference :tracks, :user, null: false, foreign_key: true
  end
end

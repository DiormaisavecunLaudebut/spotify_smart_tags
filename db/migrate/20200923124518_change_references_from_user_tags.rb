class ChangeReferencesFromUserTags < ActiveRecord::Migration[6.0]
  def change
    remove_reference :user_tags, :user_track, index: true, foreign_key: true
    add_reference :user_tags, :user, index: true, foreign_key: true
  end
end

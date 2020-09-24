class RemoveTagListFromUserTracks < ActiveRecord::Migration[6.0]
  def change
    remove_column :user_tracks, :tag_list, :string, array: true
  end
end

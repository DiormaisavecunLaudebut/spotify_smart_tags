class AddTagListToUserTrack < ActiveRecord::Migration[6.0]
  def change
    add_column :user_tracks, :tag_list, :string, array: true, default: []
  end
end

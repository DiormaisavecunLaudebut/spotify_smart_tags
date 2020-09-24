class AddTrackCountToUserTag < ActiveRecord::Migration[6.0]
  def change
    add_column :user_tags, :track_count, :integer, null: false, default: 0
  end
end

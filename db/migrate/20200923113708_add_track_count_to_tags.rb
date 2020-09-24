class AddTrackCountToTags < ActiveRecord::Migration[6.0]
  def change
    add_column :tags, :track_count, :integer, null: false, default: 0
  end
end

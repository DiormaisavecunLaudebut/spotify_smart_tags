class CreateUserTrackTags < ActiveRecord::Migration[6.0]
  def change
    create_table :user_track_tags do |t|
      t.references :user_track, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
  end
end

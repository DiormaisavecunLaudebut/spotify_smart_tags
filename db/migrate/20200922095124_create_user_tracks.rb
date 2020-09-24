class CreateUserTracks < ActiveRecord::Migration[6.0]
  def change
    create_table :user_tracks do |t|
      t.references :user, null: false, foreign_key: true
      t.references :track, null: false, foreign_key: true
      t.boolean :is_tag, null: false, default: false

      t.timestamps
    end
  end
end

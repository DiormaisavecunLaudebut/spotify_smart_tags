class CreateTracklandPlaylists < ActiveRecord::Migration[6.0]
  def change
    create_table :trackland_playlists do |t|
      t.string :name
      t.string :tags, array: true
      t.boolean :name_set
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end

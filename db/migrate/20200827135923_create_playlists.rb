class CreatePlaylists < ActiveRecord::Migration[6.0]
  def change
    create_table :playlists do |t|
      t.string :name
      t.string :cover_url
      t.string :url

      t.timestamps
    end
  end
end

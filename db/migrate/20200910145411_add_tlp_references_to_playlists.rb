class AddTlpReferencesToPlaylists < ActiveRecord::Migration[6.0]
  def change
     add_reference :trackland_playlists, :playlist, index: true, null: true
  end
end

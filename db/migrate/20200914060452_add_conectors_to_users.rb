class AddConectorsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :connectors, :string, array: true, default: []
  end
end

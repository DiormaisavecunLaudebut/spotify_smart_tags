class AddPlaytlistSortToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :playlist_sort, :string, null: false, default: 'custom'
  end
end

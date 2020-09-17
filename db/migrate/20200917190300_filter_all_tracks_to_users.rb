class FilterAllTracksToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :filter_all, :boolean, default: false
  end
end

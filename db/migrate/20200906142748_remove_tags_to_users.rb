class RemoveTagsToUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :tags, :string, array: true
  end
end

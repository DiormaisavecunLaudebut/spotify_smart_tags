class AddTagSortToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :tag_sort, :string, null: false, default: "custom"
  end
end

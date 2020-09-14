class AddRequestTagsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :request_tags, :string, array: true, default: []
  end
end

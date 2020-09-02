class AddStuffToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :country, :string
    add_column :users, :external_url, :string
    add_column :users, :display_name, :string
    add_column :users, :product, :string
    add_column :users, :followers, :integer
  end
end

class AddRewardSystemToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :points, :integer, null: false, default: 0
    add_column :users, :status, :string, null: false, default: 'amateur'
  end
end

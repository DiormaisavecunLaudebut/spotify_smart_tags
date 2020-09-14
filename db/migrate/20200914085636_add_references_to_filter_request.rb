class AddReferencesToFilterRequest < ActiveRecord::Migration[6.0]
  def change
    add_reference :filter_requests, :user, null: false, foreign_key: true
  end
end

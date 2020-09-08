class CreateDataUpdates < ActiveRecord::Migration[6.0]
  def change
    create_table :data_updates do |t|
      t.references :user, null: false, foreign_key: true
      t.string :source

      t.timestamps
    end
  end
end

class CreateSptags < ActiveRecord::Migration[6.0]
  def change
    create_table :sptags do |t|
      t.string :name
      t.integer :track_count, default: 0
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end

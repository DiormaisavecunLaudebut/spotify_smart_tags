class CreateDailyChallenges < ActiveRecord::Migration[6.0]
  def change
    create_table :daily_challenges do |t|
      t.boolean :completed, default: false
      t.integer :tracks_tagged, default: 0
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end

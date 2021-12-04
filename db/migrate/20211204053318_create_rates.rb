class CreateRates < ActiveRecord::Migration[6.1]
  def change
    create_table :rates do |t|
      t.references :user, null: false, foreign_key: true
      t.references :first_name, null: false, foreign_key: true
      t.integer :sound_rate
      t.integer :character_rate

      t.timestamps
    end
  end
end

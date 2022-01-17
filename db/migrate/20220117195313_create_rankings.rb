class CreateRankings < ActiveRecord::Migration[6.1]
  def change
    create_table :rankings do |t|
      t.integer :year, null: false
      t.integer :sex, null: false
      t.integer :rank, null: false
      t.string :name, null: false
      t.string :reading, null: false

      t.timestamps
    end
    add_index :rankings, [:year, :sex, :rank], unique: true
  end
end

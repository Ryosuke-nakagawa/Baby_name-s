class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :uuid
      t.string :line_id, null: false
      t.integer :sound_rate_setting
      t.integer :character_rate_setting
      t.integer :fortune_telling_rate_setting
      t.references :group, null: false, foreign_key: true

      t.timestamps
    end
  end
end

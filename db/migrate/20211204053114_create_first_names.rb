class CreateFirstNames < ActiveRecord::Migration[6.1]
  def change
    create_table :first_names do |t|
      t.references :group, null: false, foreign_key: true
      t.string :name, null: false
      t.string :reading
      t.string :fotune_telling_url
      t.integer :fotune_telling_rate
      t.string :fotune_telling_image

      t.timestamps
    end
  end
end

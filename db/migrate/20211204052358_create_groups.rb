class CreateGroups < ActiveRecord::Migration[6.1]
  def change
    create_table :groups do |t|
      t.string :last_name , null: false

      t.timestamps
    end
  end
end

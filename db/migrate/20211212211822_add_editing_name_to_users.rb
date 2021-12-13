class AddEditingNameToUsers < ActiveRecord::Migration[6.1]
  def change
    add_reference :users, :editing_name, foreign_key: { to_table: :first_names }
  end
end

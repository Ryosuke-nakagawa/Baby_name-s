class ChangeUniqeIndexLineidOfUser < ActiveRecord::Migration[6.1]
  def change
    add_index :users, :line_id, unique: true
  end
end

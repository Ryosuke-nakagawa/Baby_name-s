class AddDetailsToFirstNames < ActiveRecord::Migration[6.1]
  def change
    add_column :first_names, :fortune_telling_heaven, :integer
    add_column :first_names, :fortune_telling_person, :integer
    add_column :first_names, :fortune_telling_land, :integer
    add_column :first_names, :fortune_telling_outside, :integer
    add_column :first_names, :fortune_telling_all, :integer
    add_column :first_names, :fortune_telling_talent, :integer
  end
end

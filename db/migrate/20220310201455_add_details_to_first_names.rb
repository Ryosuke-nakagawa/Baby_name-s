class AddDetailsToFirstNames < ActiveRecord::Migration[6.1]
  def change
    add_column :first_names, :fortune_telling_heaven, :string
    add_column :first_names, :fortune_telling_person, :string
    add_column :first_names, :fortune_telling_land, :string
    add_column :first_names, :fortune_telling_outside, :string
    add_column :first_names, :fortune_telling_all, :string
    add_column :first_names, :fortune_telling_talent, :string
  end
end

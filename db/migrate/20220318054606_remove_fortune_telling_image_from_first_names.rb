class RemoveFortuneTellingImageFromFirstNames < ActiveRecord::Migration[6.1]
  def up
    remove_column :first_names, :fortune_telling_image, :string
  end

  def down
    add_column :first_names, :fortune_telling_image, :string
  end
end

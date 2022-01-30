class RenameFotuneTellingColumnToFirstNames < ActiveRecord::Migration[6.1]
  def change
    rename_column :first_names, :fotune_telling_image, :fortune_telling_image
    rename_column :first_names, :fotune_telling_rate, :fortune_telling_rate
    rename_column :first_names, :fotune_telling_url, :fortune_telling_url
  end
end

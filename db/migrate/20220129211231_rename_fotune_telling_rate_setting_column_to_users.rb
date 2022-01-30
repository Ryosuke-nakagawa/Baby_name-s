class RenameFotuneTellingRateSettingColumnToUsers < ActiveRecord::Migration[6.1]
  def change
    rename_column :users, :fotune_telling_rate_setting, :fortune_telling_rate_setting
  end
end

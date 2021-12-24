class FirstName < ApplicationRecord
  belongs_to :group
  has_many :rates

  def self.sort_by_overall_rating(first_names,group_users)
    score = {}

    first_names.each do |first_name|
      sum = 0
      group_users.each do |user|
        rate = Rate.find_by(first_name: first_name,user: user)
        break if rate.nil?
        sound_rate = rate.sound_rate * user.sound_rate_setting
        character_rate = rate.character_rate * user.character_rate_setting
        fotune_telling_rate = first_name.fotune_telling_rate * user.fotune_telling_rate_setting
        sum = sound_rate + character_rate + fotune_telling_rate
      end
      result = sum / group_users.count
      score[result] = first_name # {合計点 => first_name }ができる
    end
    sorted_score = score.sort.reverse
    sorted_first_names = []
    sorted_score.map{ |result, first_name| sorted_first_names << first_name }
    return sorted_first_names
  end
end

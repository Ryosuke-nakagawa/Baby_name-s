class FirstName < ApplicationRecord
  belongs_to :group
  has_many :rates

  scope :order_by_sound, ->(group_id) { where(group_id: group_id).joins(:rates).group(:id).order('average_rates_sound_rate DESC').average("rates.sound_rate") }
  scope :order_by_character, ->(group_id) { where(group_id: group_id).joins(:rates).group(:id).order('average_rates_character_rate DESC').average("rates.character_rate") }
  scope :order_by_fotune_telling, ->(group_id) { where(group_id: group_id).order('fotune_telling_rate DESC') }

  def self.sort_by_overall_rating(first_names,group_users)
    score = {}

    first_names.each_with_index do |first_name, i|
      sum = 0
      user_count = group_users.count
      group_users.each do |user|
        rate = Rate.find_by(first_name: first_name,user: user)
        if rate.nil?
          user_count -= 1
          next
        end
        # userの評価基準と、実際の評価を掛け合わせて総評価の点をsumで出力
        sound_rate = rate.sound_rate * user.sound_rate_setting
        character_rate = rate.character_rate * user.character_rate_setting
        fotune_telling_rate = first_name.fotune_telling_rate * user.fotune_telling_rate_setting
        sum = sound_rate + character_rate + fotune_telling_rate
      end
      if user_count.zero?
        # 名前の評価がまだない場合1以下で定義
        result = "0.#{i}1".to_f
      else
        result = sum / user_count
        # 同点で被るとハッシュ変換時に上書きしてしまうので、一意の数にするためにiを少数に追加
        result = "#{result}.#{i}1".to_f
      end
      score[result] = first_name # {合計点 => first_name }ができる
    end
    sorted_score = score.sort.reverse
    sorted_first_names = []
    sorted_score.map{ |result, first_name| sorted_first_names << first_name }
    return sorted_first_names
  end
end

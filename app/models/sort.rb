class Sort
  def by_overall_rating(first_names, group_users)
    score = {}

    first_names.each_with_index do |first_name, i|
      sum = 0
      user_count = group_users.count
      group_users.each do |user|
        rate = Rate.find_by(first_name: first_name, user: user)
        if rate.nil?
          user_count -= 1
          next
        end
        # userの評価基準と、実際の評価(rate)を掛け合わせて総評価の点をsumで出力
        sound_rate = rate.sound_rate.to_i * user.sound_rate_setting.to_i
        character_rate = rate.character_rate.to_i * user.character_rate_setting.to_i
        fortune_telling_rate = first_name.fortune_telling_rate.to_i * user.fortune_telling_rate_setting.to_i
        sum = sound_rate + character_rate + fortune_telling_rate
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
    sorted_score.map { |_result, first_name| sorted_first_names << first_name }
    sorted_first_names
  end
end

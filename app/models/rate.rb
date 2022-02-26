class Rate < ApplicationRecord
  belongs_to :user
  belongs_to :first_name

  def self.ratings_within_group(first_name, group)
    member = group.users
    rates = []

    member.each do |user|
      rate = Rate.find_by(user: user, first_name: first_name)
      rates << rate unless rate.nil?
    end

    rates
  end

  def self.sound_average(rates)
    return if rates.blank?

    sum = 0
    rates.each do |rate|
      sum += rate.sound_rate.to_f
    end
    average = sum / rates.length
    # 0.5刻みに評価の数値を丸める
    average *= 2
    result = average.round
    result / 2.0
  end

  def self.character_average(rates)
    return if rates.blank?

    sum = 0
    rates.each do |rate|
      sum += rate.character_rate.to_f
    end
    average = sum / rates.length
    # 0.5刻みに評価の数値を丸める
    average *= 2
    result = average.round
    result / 2.0
  end
end

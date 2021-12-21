module RatesHelper
  def sound_average(rates)
    return if rates.blank?
    sum = 0
    rates.each do |rate|
      sum += rate.sound_rate
    end
    average = sum / rates.length
    # 0.5刻みに評価の数値を丸める
    average *= 2
    result = average.round
    result /= 2.0
    return result
  end

  def character_average(rates)
    return if rates.blank?
    sum = 0
    rates.each do |rate|
      sum = rate.character_rate
    end
    average = sum / rates.length.to_f
    # 0.5刻みに評価の数値を丸める
    average *= 2
    result = average.round
    result /= 2.0
    return result
  end
end

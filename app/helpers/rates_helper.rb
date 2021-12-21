module RatesHelper
  def sound_average(rates)
    sum = 0
    rates.each do |rate|
      sum += rate.sound_rate
    end
    average = sum / rates.length
    return average.to_f
  end
end

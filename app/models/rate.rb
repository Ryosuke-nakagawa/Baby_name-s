class Rate < ApplicationRecord
  belongs_to :user
  belongs_to :first_name

  def self.add_rate_for_group_member(first_name,group)
    member = group.users
    rates = []
    member.each do |user|
      rates << Rate.find_by(user: user,first_name: first_name)
    end
    return rates
  end

  def sound_average
    sum = 0
    self.each do |rate|
      sum = rate.sound_rate
    end
    return sum / self.length
  end
end

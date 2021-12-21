class Rate < ApplicationRecord
  belongs_to :user
  belongs_to :first_name

  def self.add_rate_for_group_member(first_name,group)
    member = group.users
    rates = []

    member.each do |user|
      rate = Rate.find_by(user: user,first_name: first_name)
      rates << rate unless rate.nil?
    end

    return rates
  end
end

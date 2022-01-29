class FirstName < ApplicationRecord
  belongs_to :group
  has_many :rates, dependent: :destroy
  has_many :likes, dependent: :destroy

  scope :order_by_sound, lambda { |group_id|
                           where(group_id: group_id).joins(:rates).group(:id).order('average_rates_sound_rate DESC NULLS LAST').average('rates.sound_rate')
                         }
  scope :order_by_character, lambda { |group_id|
                               where(group_id: group_id).joins(:rates).group(:id).order('average_rates_character_rate DESC NULLS LAST').average('rates.character_rate')
                             }
  scope :order_by_fortune_telling, lambda { |group_id|
                                     where(group_id: group_id).order('fortune_telling_rate DESC NULLS LAST')
                                   }

  def rated?(user)
    rates.find_by(user_id: user.id)
  end
end

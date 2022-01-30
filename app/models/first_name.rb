class FirstName < ApplicationRecord
  belongs_to :group
  has_many :rates, dependent: :destroy
  has_many :likes, dependent: :destroy

  scope :order_by_sound, -> { joins(:rates).group(:id).order('average_rates_sound_rate DESC NULLS LAST').average('rates.sound_rate') }
  scope :order_by_character, -> { joins(:rates).group(:id).order('average_rates_character_rate DESC NULLS LAST').average('rates.character_rate') }
  scope :order_by_fortune_telling, -> { order('fortune_telling_rate DESC NULLS LAST') }

  def rated?(user)
    rates.find_by(user_id: user.id)
  end

  def self.order_by(sort_type,first_names)
    case sort_type
    when 'sound'
      result = first_names.order_by_sound
      result.map { |first_name_id, _average| FirstName.find(first_name_id) }
    when 'character'
      result = first_names.order_by_character
      result.map { |first_name_id, _average| FirstName.find(first_name_id) }
    when 'fortune_telling'
      first_names.order_by_fortune_telling
    else
      calculation_result_service = CalculationResultService.new(first_names, first_names.first.group.users)
      calculation_result_service.by_overall_rating
    end
  end
end

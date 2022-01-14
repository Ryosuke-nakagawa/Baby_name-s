class User < ApplicationRecord
  belongs_to :group
  belongs_to :editing_name, class_name: 'FirstName', optional: true
  has_many :rates, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :like_first_names, through: :likes, source: :first_name

  validates :line_id, presence: true, uniqueness: true
  validates :sound_rate_setting, numericality: { in: 1..3 }, allow_nil: true
  validates :character_rate_setting, numericality: { in: 1..3 }, allow_nil: true
  validates :fotune_telling_rate_setting, numericality: { in: 1..3 }, allow_nil: true

  enum status: { normal: 0, name: 1, reading: 2, sound_rate: 3, character_rate: 4 }

  before_create -> { self.uuid = SecureRandom.uuid }

  def like?(first_name)
    like_first_names.include?(first_name)
  end

  def like(first_name)
    like_first_names << first_name
  end

  def unlike(first_name)
    like_first_names.destroy(first_name)
  end
end

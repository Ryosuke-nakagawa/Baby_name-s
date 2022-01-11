class User < ApplicationRecord
  belongs_to :group
  belongs_to :editing_name, class_name:'FirstName', optional: true
  has_many :rates
  has_many :likes
  has_many :like_first_names, through: :likes, source: :first_name

  validates :line_id, presence: true, uniqueness: true
  validates :sound_rate_setting, numericality: { in: 1..5  }, allow_nil: true
  validates :character_rate_setting, numericality: { in: 1..5  }, allow_nil: true
  validates :fotune_telling_rate_setting, numericality: { in: 1..5  }, allow_nil: true

  enum status: { normal: 0, name_registration: 1, reading_registration: 2 , sound_rate_registration: 3 , character_rate_registration: 4 }

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

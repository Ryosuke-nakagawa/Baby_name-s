class User < ApplicationRecord
  belongs_to :group
  belongs_to :editing_name, class_name:'FirstName', optional: true
  has_many :rates
  has_many :likes_first_names, through: :likes, source: :first_name

  validates :line_id, presence: true, uniqueness: true
  validates :sound_rate_setting, numericality: { in: 1..5  }, allow_nil: true
  validates :character_rate_setting, numericality: { in: 1..5  }, allow_nil: true
  validates :fotune_telling_rate_setting, numericality: { in: 1..5  }, allow_nil: true

  enum status: { normal: 0, name_registration: 1, reading_registration: 2 , sound_rate_registration: 3 , character_rate_registration: 4 }

  before_create -> { self.uuid = SecureRandom.uuid }
end

class User < ApplicationRecord
  belongs_to :group

  validates :line_id, presence: true, uniqueness: true
  validates :sound_rate_setting, numericality: { in: 1..5  }, allow_nil: true
  validates :character_rate_setting, numericality: { in: 1..5  }, allow_nil: true
  validates :fotune_telling_rate_setting, numericality: { in: 1..5  }, allow_nil: true

  before_create -> { self.uuid = SecureRandom.uuid }
end

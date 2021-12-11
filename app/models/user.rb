class User < ApplicationRecord
  belongs_to :group

  before_create -> { self.uuid = SecureRandom.uuid }
end

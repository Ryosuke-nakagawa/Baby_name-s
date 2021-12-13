class FirstName < ApplicationRecord
  belongs_to :group
  has_one :User
end

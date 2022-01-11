class Like < ApplicationRecord
  belongs_to :first_name
  belongs_to :user

  validates :user_id, uniqueness: { scope: :first_name_id }
end

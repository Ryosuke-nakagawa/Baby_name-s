class Like < ApplicationRecord
  belongs_to :first_name
  belongs_to :user

  validates :user_id, uniqueness: { scoope: :first_name }
end

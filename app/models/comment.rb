class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :first_name

  validates :body, presence: true
end

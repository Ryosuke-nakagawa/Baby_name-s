class Group < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :first_names, dependent: :destroy
  accepts_nested_attributes_for :users

  validates :last_name, length: { maximum: 20 }, allow_nil: true
end

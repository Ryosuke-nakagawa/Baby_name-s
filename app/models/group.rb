class Group < ApplicationRecord
  has_many :users
  accepts_nested_attributes_for :users, allow_destroy: true
end

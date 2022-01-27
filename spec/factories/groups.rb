FactoryBot.define do
  factory :group do
    sequence(:last_name) { |n| "last_name#{n}"}
  end
end
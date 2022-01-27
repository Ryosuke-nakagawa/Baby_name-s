FactoryBot.define do
    factory :first_name do
      sequence(:name) { |n| "first_name#{n}"}
      sequence(:reading) { |n| "first_name#{n}"}
    end
  end
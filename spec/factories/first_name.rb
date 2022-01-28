FactoryBot.define do
    factory :first_name do
      sequence(:name) { |n| "first_name#{n}"}
      sequence(:reading) { |n| "first_name#{n}"}
      fotune_telling_rate { 4 }
    end
  end
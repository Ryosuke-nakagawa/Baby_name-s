FactoryBot.define do
    factory :first_name do
      sequence(:name) { |n| "first_name#{n}"}
      sequence(:reading) { |n| "reading#{n}"}
      fotune_telling_rate { rand(1..5) }
    end
  end
FactoryBot.define do
  factory :user do
    sequence(:line_id) { |n| "TEST_LINE_ID_#{n}"}
    group
  end
end
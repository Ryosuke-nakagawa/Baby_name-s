FactoryBot.define do
  factory :comment do
    sequence(:body) { |n| "comment_#{n}"}
  end
end

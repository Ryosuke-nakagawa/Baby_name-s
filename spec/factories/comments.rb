FactoryBot.define do
  factory :comment do
    user { nil }
    first_name { nil }
    body { "MyString" }
  end
end

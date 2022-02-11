FactoryBot.define do
  factory :user do
    sequence(:line_id) { |n| "TEST_LINE_ID_#{n}"}
    sound_rate_setting { rand(1..3) }
    character_rate_setting { rand(1..3) }
    fortune_telling_rate_setting { rand(1..3) }
    group

    trait :admin do
      name { 'admin' }
      role { 10 }
    end

    trait :general do
      name { 'general' }
      role{ 0 }
    end
  end
end
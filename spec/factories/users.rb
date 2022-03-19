FactoryBot.define do
  factory :user do
    sequence(:line_id) { |n| "TEST_LINE_ID_#{n}"}
    sound_rate_setting { rand(1..3) }
    character_rate_setting { rand(1..3) }
    fortune_telling_rate_setting { rand(1..3) }
    group

    trait :admin do
      name { 'admin_user' }
      role { 10 }
    end

    trait :general do
      name { 'general_user' }
      role{ 0 }
    end

    trait :real_account do
      line_id { ENV['MY_LINE_ID'] }
    end
  end
end
FactoryBot.define do
  factory :rate do
    sound_rate { rand(1..5) }
    character_rate { rand(1..5) }
  end
end
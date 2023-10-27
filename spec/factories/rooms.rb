FactoryBot.define do
  factory :room do
    name            { Faker::Alphanumeric.alpha(number: 10) }
    is_private      { false }

    trait :private do
      name            { nil }
      is_private      { true }
    end

    factory :private_room, traits: [:private]
  end
end

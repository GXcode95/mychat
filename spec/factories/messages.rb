FactoryBot.define do
  factory :message do
    room
    author            { create(:user) }
    content           { Faker::Lorem.sentences(number: 3) }
  end
end

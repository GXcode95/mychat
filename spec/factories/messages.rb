FactoryBot.define do
  factory :message do
    room
    author            { create(:user) }
    content           { Faker::Lorem.sentence }
  end
end

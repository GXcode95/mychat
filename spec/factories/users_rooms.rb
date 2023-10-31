FactoryBot.define do
  factory :users_room do
    user
    room
    role              { UsersRoom::ROLES.sample }
    status            { :accepted }

    trait :owner do
      role            { :owner }
    end

    trait :admin do
      role            { :admin }
    end

    trait :member do
      role            { :member }
    end

    trait :pending do
      status          { :pending }
    end

    factory :users_room_owner, traits: [:owner]
    factory :users_room_admin, traits: [:admin]
    factory :users_room_member, traits: [:member]
    factory :users_room_pending, traits: [:member]
  end
end

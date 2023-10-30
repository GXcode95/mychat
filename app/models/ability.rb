# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    return if user.nil?

    can :create, Message do |message|
      message.room.role_of(user).present?
    end
    can :manage, Message do |message|
      message.author == user || message.room.owner?(user) ||
        message.room.admin?(user) && message.room.is_public?
    end

    can %i[create destroy], UsersRoom, user: user
    can %i[update destroy], UsersRoom do |users_room|
      users_room.room.admin?(user)
    end
    can :manage, UsersRoom do |users_room|
      users_room.room.owner?(user)
    end
    
    can :create, Room
    can :read, Room do |room|
      room.role_of(user).present?
    end
    can :update, Room do |room|
      room.admin?(user)
    end
    can :manage, Room do |room|
      room.owner?(user)
    end
  end
end

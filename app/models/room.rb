# == Schema Information
#
# Table name: rooms
#
#  id         :bigint           not null, primary key
#  is_private :boolean          default(FALSE), not null
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Room < ApplicationRecord
  NAME_MAX_LENGTH = 20

  has_many :messages, dependent: :destroy
  has_many :users_rooms, dependent: :destroy
  has_many :users, through: :users_rooms

  has_many :accepted_users_rooms, -> { where(status: :accepted) },
           dependent: :destroy,
           class_name: :UsersRoom
  has_many :accepted_users, through: :accepted_users_rooms, source: :user

  has_one :users_room_owner, -> { where(role: :owner) },
          dependent: :destroy,
          class_name: :UsersRoom
  has_one :owner, through: :users_room_owner, source: :user

  scope :public_rooms, -> { where(is_private: false) }
  scope :private_rooms, -> { where(is_private: true) }
  # scope :by_users, lambda { |*users|
  #   private_rooms.
  #     select('rooms.*').
  #     joins(:users_rooms).
  #     where(users_rooms: { user_id: users.pluck(:id) }).
  #     group('rooms.id').
  #     having('COUNT(users_rooms.user_id) >= ?', users.size)
  # }

  accepts_nested_attributes_for :users_rooms, allow_destroy: true

  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: NAME_MAX_LENGTH }, if: -> { !is_private }

  def owner?(user)
    user == owner
  end

  def member?(user)
    role_of(user) == 'member'
  end

  def admin?(user)
    role_of(user) == 'admin'
  end

  def is_public?
    !is_private
  end

  def display_name_for(current_user = nil)
    return name if is_public?

    recipient = users.find { |user| user != current_user }
    recipient.email
  end

  def self.by_users(*users)
    private_rooms.
      select('rooms.*').
      joins(:users_rooms).
      where(users_rooms: { user_id: users.pluck(:id) }).
      group('rooms.id').  
      having('COUNT(users_rooms.user_id) >= ?', users.size).first
  end

  def role_of(user)
    accepted_users_rooms.find_by(user: user)&.role
  end
end

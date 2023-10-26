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

  accepts_nested_attributes_for :users_rooms, allow_destroy: true

  validates :name, length: { maximum: 20 }
  validates :name, presence: true, uniqueness: { case_sensitive: false }, if: -> { !is_private }

  def owner?(user)
    user == owner
  end

  def self.by_users(*users)
    user_ids = users.pluck(:id)

    select('rooms.*, COUNT(users_rooms.user_id)')
      .joins(:users_rooms)
      .where(users_rooms: { user_id: user_ids })
      .group('rooms.id')
      .having('COUNT(users_rooms.user_id) = ?', user_ids.size)
  end
end

# == Schema Information
#
# Table name: rooms
#
#  id         :bigint           not null, primary key
#  is_private :boolean          default(FALSE), not null
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_rooms_on_name  (name) UNIQUE
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

  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 20 }

  def owner?(user)
    user == owner
  end
end

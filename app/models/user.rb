# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  last_online_at         :datetime
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  status                 :integer          default("offline"), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  scope :all_except, ->(user) { where.not(id: user) }

  has_many :users_rooms, dependent: :destroy
  has_many :rooms, through: :users_rooms

  has_many :public_rooms, -> { where(rooms: { is_private: false }) },
           through: :users_rooms, source: :room

  has_many :joined_users_rooms, -> { where(status: :accepted) },
           dependent: :destroy, class_name: :UsersRoom, inverse_of: :user
  has_many :joined_rooms, through: :joined_users_rooms, source: :room
  has_many :private_rooms, -> { where(rooms: { is_private: true }) },
           through: :joined_users_rooms, source: :room
  has_many :joined_public_rooms, -> { where(rooms: { is_private: false }) },
           through: :joined_users_rooms, source: :room

  enum :status, {
    offline: 0,
    online: 1
  }
  after_update_commit ->(user) { user.broadcast_replace_status_to_each_users },
                      if: ->(user) { user.previous_changes[:status] }

  def private_room_with(user)
    private_rooms.joins(:users).find_by(users: { id: user })
  end

  def broadcast_replace_status_to_each_users
    rooms.each do |room|
      room.accepted_users.all_except(self).each do |room_user|
        broadcast_replace_to("room_#{room.id}_show",
                             target: "panel_user_#{id}",
                             partial: 'users/panel_user',
                             locals: { user: self, current_user: room_user })
      end
    end
  end
end

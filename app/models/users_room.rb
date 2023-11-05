# == Schema Information
#
# Table name: users_rooms
#
#  id         :bigint           not null, primary key
#  role       :integer          not null
#  status     :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  room_id    :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_users_rooms_on_room_id  (room_id)
#  index_users_rooms_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (room_id => rooms.id)
#  fk_rails_...  (user_id => users.id)
#

class UsersRoom < ApplicationRecord
  STATUS = %w[accepted pending].freeze
  ROLES = %w[owner admin member].freeze
  belongs_to :user
  belongs_to :room

  enum :role, ROLES
  enum :status, STATUS

  before_validation :set_status_and_role, if: ->(users_room) { users_room&.room&.is_private }

  validates :status, presence: true, inclusion: { in: STATUS }
  validates :role, presence: true, inclusion: { in: ROLES }
  validates :role, uniqueness: { scope: :room_id }, if: -> { owner? }
  validates :user_id, presence: true, uniqueness: { scope: :room_id }

  validate :room_is_not_full, on: :create

  after_destroy_commit do |users_room|
    users_room.broadcast_update_to_rooms_for_user
    users_room.broadcast_remove_to_room_settings_members
    users_room.broadcast_remove_to_room_settings_requests
    users_room.broadcast_remove_to_panel_room_for_user
  end

  after_create_commit ->(users_room) { users_room.broadcast_append_to_room_settings_requests }

  after_update_commit do |users_room|
    users_room.broadcast_remove_to_room_settings_requests
    users_room.broadcast_append_to_room_settings_members
    users_room.broadcast_update_to_rooms_for_user
    users_room.broadcast_append_to_panel_public_rooms_for_user if users_room.previous_changes[:status]
  end

  def broadcast_append_to_room_settings_requests
    broadcast_append_to("room_#{room_id}_settings",
                        target: "room_#{room.id}_requests",
                        partial: 'rooms/user_list_item',
                        locals: { users_room: self })
  end

  def broadcast_append_to_room_settings_members
    broadcast_append_to("room_#{room_id}_settings",
                        target: 'rooms_member',
                        partial: 'rooms/user_list_item',
                        locals: { users_room: self })
  end

  def broadcast_append_to_panel_public_rooms_for_user
    broadcast_append_to("user_#{user_id}",
                        target: 'panel_public_rooms',
                        partial: 'rooms/panel_room',
                        locals: { room: room, user: user })
  end

  def broadcast_update_to_rooms_for_user
    broadcast_update_to("user_#{user_id}",
                        target: "room_#{room_id}",
                        partial: 'rooms/room',
                        locals: { room: room, current_user: user })
  end

  def broadcast_remove_to_room_settings_requests
    broadcast_remove_to("room_#{room_id}_settings", target: "request_users_room_#{id}")
  end

  def broadcast_remove_to_room_settings_members
    broadcast_remove_to("room_#{room_id}_settings", target: "member_users_room_#{id}")
  end

  def broadcast_remove_to_panel_room_for_user
    broadcast_remove_to("user_#{user_id}", target: "panel-room-#{room_id}")
  end

  private

  def set_status_and_role
    self.status = :accepted
    self.role = :member
  end

  def room_is_not_full
    return if room.nil? || room.is_public? || room.users_rooms.size <= 2

    errors.add(:room, 'This room is private and full.')
  end


end

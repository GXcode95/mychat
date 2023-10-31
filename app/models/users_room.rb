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

  private

  def set_status_and_role
    self.status = :accepted
    self.role = :admin
  end

  def room_is_not_full
    return if room.nil? || room.is_public? || room.users_rooms.size <= 2

    errors.add(:room, 'This room is private and full.')
  end
end

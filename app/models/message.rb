# == Schema Information
#
# Table name: messages
#
#  id         :bigint           not null, primary key
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  author_id  :bigint           not null
#  room_id    :bigint           not null
#
# Indexes
#
#  index_messages_on_author_id  (author_id)
#  index_messages_on_room_id    (room_id)
#
# Foreign Keys
#
#  fk_rails_...  (author_id => users.id)
#  fk_rails_...  (room_id => rooms.id)
#
class Message < ApplicationRecord
  belongs_to :author, class_name: 'User'
  belongs_to :room

  validates :content, presence: true, length: { maximum: 500 }

  broadcasts_to ->(message) { [message.room, 'messages'] }, inserts_by: :append
end

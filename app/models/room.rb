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
  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 20 }

  scope :public_rooms, -> { where(is_private: false) }

  broadcasts_to ->(_) { 'rooms' }, inserts_by: :append
end

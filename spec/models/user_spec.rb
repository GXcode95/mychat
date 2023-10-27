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
require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:private_room) { create(:private_room) }
  let!(:user_users_room) { create(:users_room_admin, user: user, room: private_room) }
  let!(:other_user_users_room) { create(:users_room_admin, user: other_user, room: private_room) }

  describe 'Create a record' do
    it 'is valid' do
      expect(user).to be_valid
    end

    context 'is not valid' do
      it 'if no email is given' do
        user.email = nil
        expect(user).to_not be_valid
      end

      it 'if email is already taken' do
        user2 = build(:user, email: user.email)
        expect(user2).to_not be_valid
      end
    end
  end

  describe 'private_room_with(user)' do
    context 'when room exist' do
      it 'it returns the room' do
        room = user.private_room_with(other_user)
        expect(room).to eq(private_room)
      end
    end

    context 'when room doesn\'t exist' do
      it 'it returns nil' do
        unrelated_user = create(:user)
        room = user.private_room_with(unrelated_user)
        expect(room).to eq(nil)
      end
    end

    context 'when user doesn\'t exist' do
      it 'it returns nil' do
        room = user.private_room_with(nil)
        expect(room).to eq(nil)
      end
    end
  end
end

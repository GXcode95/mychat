require 'rails_helper'

RSpec.describe UsersRoom, type: :model do
  let(:users_room_owner) { create(:users_room_owner) }
  let(:users_room_admin) { create(:users_room_admin, room: users_room_owner.room) }
  let(:users_room_member) { create(:users_room_member, room: users_room_owner.room) }
  let(:users_room_pending) { create(:users_room_pending, room: users_room_owner.room) }

  describe 'Create a record' do
    context 'factories' do
      it 'it is valid' do
        expect(users_room_owner).to be_valid
        expect(users_room_admin).to be_valid
        expect(users_room_member).to be_valid
        expect(users_room_pending).to be_valid
      end
    end

    context 'room is missing' do
      it 'it is not valid' do
        users_room = build(:users_room, room_id: nil)
        expect(users_room).to_not be_valid
      end
    end

    context 'user is missing' do
      it 'it is not valid' do
        users_room = build(:users_room, user_id: nil)
        expect(users_room).to_not be_valid
      end
    end

    context 'when room is public' do
      context 'when status is missing' do
        it 'it is not valid' do
          users_room = build(:users_room, status: nil)
          expect(users_room).to_not be_valid
        end
      end

      context 'when role is missing' do
        it 'is not valid' do
          users_room = build(:users_room, role: nil)
          expect(users_room).to_not be_valid
        end
      end
    end

    context 'when room is private' do
      context 'when status or role is missing' do
        it 'it set status and role to default values and is valid' do
          users_room = build(:users_room, status: nil, role: nil, room: create(:private_room), user: users_room_owner.user)
          users_room.send(:set_status_and_role)

          expect(users_room).to be_valid
          expect(users_room.role).to eq('admin')
          expect(users_room.status).to eq('accepted')
        end
      end
    end
  end
end

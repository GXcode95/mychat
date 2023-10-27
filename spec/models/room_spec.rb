require 'rails_helper'
COUNT = 3

RSpec.describe Room, type: :model do
  let(:public_room) { create(:room) }
  let!(:public_users_room_owner) { create(:users_room_owner, room: public_room) }
  let!(:public_users_room_member) { create(:users_room_member, room: public_room) }

  let(:private_room) { create(:private_room) }
  let!(:private_users_room_member) { create(:users_room_member, room: private_room) }
  let!(:private_users_room_other_member) { create(:users_room_member, room: private_room) }

  describe 'Create a record' do
    context 'with factories' do
      it 'is valid' do
        expect(public_room).to be_valid
        expect(private_room).to be_valid
      end
    end

    context 'when is private but don\'t have name' do
      it 'is valid' do
        room = build(:private_room, name: nil)
        expect(room).to be_valid
      end
    end

    context 'when is public but don\'t have name' do
      it 'is not valid' do
        room = build(:room, name: nil)
        expect(room).to_not be_valid
      end
    end

    context 'when name is more than Room::NAME_MAX_LENGTH chars' do
      it 'is not valid' do
        room = build(:room, name: Faker::Alphanumeric.alpha(number: Room::NAME_MAX_LENGTH + 1))
        expect(room).to_not be_valid
      end
    end
  end

  describe 'Scopes' do
    describe 'public_rooms' do
      it 'return all public rooms' do
        public_rooms_size = Room.public_rooms.size
        expect(public_rooms_size).to eq(1)
      end
    end

    describe 'private_rooms' do
      it 'return all private rooms' do
        private_rooms_size = Room.private_rooms.size
        expect(private_rooms_size).to eq(1)
      end
    end

    describe 'by_users(*users)' do
      context 'when there is a room' do
        it 'return the room' do
          user1, user2 = private_room.users
          room = Room.by_users(user1, user2)
          expect(room).to eq(private_room)
        end
      end

      context 'when there is no room' do
        it 'return nil' do
          room = Room.by_users(public_room.users.first, private_room.users.first)
          expect(room).to eq(nil)
        end
      end
    end
  end

  describe 'display_name_for' do
    context 'when room is public' do
      it 'return room name' do
        member = public_users_room_member.user
        expect(public_room.display_name_for).to         eq(public_room.name)
        expect(public_room.display_name_for(member)).to eq(public_room.name)
      end
    end
  end

  describe 'display_name_for' do
    context 'when room is private' do
      it 'return the email of the other user in the room' do
        member1, member2 = private_room.users
        email = private_room.display_name_for(member1)
        email2 = private_room.display_name_for(member2)

        expect(email).to  eq(member2.email)
        expect(email2).to eq(member1.email)
      end
    end
  end

  describe 'owner?(user)' do
    context 'when user is owner' do
      it 'return true' do
        public_room.owner?(public_room)
      end
    end

    context 'when user is not owner' do
      it 'return false' do
        public_room.owner?(private_room)
      end
    end
  end

  describe 'is_public?' do
    it 'return opposite of is_private' do
      expect(public_room.is_public?).to  eq(!public_room.is_private)
      expect(private_room.is_public?).to eq(!private_room.is_private)
    end
  end

end

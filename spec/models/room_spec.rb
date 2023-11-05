require 'rails_helper'

RSpec.describe Room, type: :model do
  let(:public_room) { create(:room) }
  let!(:public_users_room_owner) { create(:users_room_owner, room: public_room) }
  let!(:public_users_room_member) { create(:users_room_member, room: public_room) }
  let!(:public_users_room_admin) { create(:users_room_admin, room: public_room) }

  let(:private_room) { create(:private_room) }
  let!(:private_users_room_member) { create(:users_room_member, room: private_room) }
  let!(:private_users_room_other_member) { create(:users_room_member, room: private_room) }

  describe '' do
    before do
      # when using after_create_commit, relation from room to users aren't disponible.
      # Reload the rooms before the test fix this issue.
      public_room.reload
      private_room.reload
    end

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
        context 'when thepre is a room' do
          fit 'return the room' do
            user1, user2 = private_room.users
            byebug
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
          public_room.owner?(public_room.owner)
        end
      end

      context 'when user is not owner' do
        it 'return false' do
          public_room.owner?(public_users_room_member.user)
        end
      end
    end

    describe 'member?(user)' do
      context 'when user is member' do
        it 'return true' do
          public_room.member?(public_users_room_member.user)
        end
      end

      context 'when user is not member' do
        it 'return false' do
          public_room.member?(public_room.owner)
        end
      end
    end

    describe 'admin?(user)' do
      context 'when user is admin' do
        it 'return true' do
          public_room.admin?(public_users_room_admin.user)
        end
      end

      context 'when user is not admin' do
        it 'return false' do
          public_room.admin?(public_room.owner)
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
end

require 'rails_helper'

RSpec.describe RoomComponent, type: :component do
  let!(:users_room_member) { create(:users_room_member) }
  let(:room) { users_room_member.room }
  let(:member) { users_room_member.user }

  let!(:users_room_pending) { create(:users_room_pending, room: room) }
  let(:user_pending) { users_room_pending.user }

  let(:user) { create(:user) }

  context 'when user already joined the room' do
    it 'renders component with leave action' do
      render_inline(described_class.new(room, user: member))
      expect(page).to have_css "form[action=\"/users_rooms/#{users_room_member.id}\"]", text: 'Leave'
    end

    it 'renders link_to room' do
      render_inline(described_class.new(room, user: member))
      expect(page).to have_css "a[href=\"/rooms/#{room.id}\"]", text: room.name
    end
  end

  context 'when user is not related to the room' do
    it 'renders component with join action' do
      render_inline(described_class.new(room, user: user))
      expect(page).to have_css 'form[action="/users_rooms"]', text: 'Join'
    end

    it 'display room name' do
      render_inline(described_class.new(room, user: user))
      expect(page).to have_css 'span', text: room.name
    end
  end

  context 'when user is waiting for approval to the room' do
    it 'renders component with request send in a disabled button' do
      render_inline(described_class.new(room, user: user_pending))
      expect(page).to have_css 'form[action="/users_rooms"]>button[disabled="disabled"]',
                               text: 'Request send'
    end

    it 'display room name' do
      render_inline(described_class.new(room, user: user_pending))
      expect(page).to have_css 'span', text: room.name
    end
  end
end

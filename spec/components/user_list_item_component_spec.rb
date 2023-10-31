require 'rails_helper'

RSpec.describe UserListItemComponent, type: :component do
  let(:users_room) { create(:users_room) }
  let(:users_room_pending) { create(:users_room_pending) }

  context 'when  user is accepted in the room' do
    it 'renders component with delete button' do
      render_inline(described_class.new(users_room))

      expect(page).to have_css "form[action=\"/users_rooms/#{users_room.id}\"]", text: 'Delete'
    end
  end

  context 'when user request is pending' do
    it 'renders component with accept and reject buttons' do
      render_inline(described_class.new(users_room_pending))

      expect(page).to have_css "form[action=\"/users_rooms/#{users_room_pending.id}\"]", text: 'Reject'
      expect(page).to have_css "form[action=\"/users_rooms/#{users_room_pending.id}\"]", text: 'Accept'
    end
  end
end

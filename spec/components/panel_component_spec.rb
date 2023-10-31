require 'rails_helper'

RSpec.describe PanelComponent, type: :component do
  let(:users_room_member) { create(:users_room_member) }
  let(:member) { users_room_member.user }
  let(:room) { users_room_member.room }
  let(:users_room_owner) { create(:users_room_owner, room: room) }
  let(:owner) { users_room_owner.user }
  let(:users_room_admin) { create(:users_room_admin, room: room) }
  let(:admin) { users_room_admin.user }

  context 'with left variant' do
    it 'renders component on left' do
      render_inline(described_class.new(user: member, variant: :left))

      expect(page).to have_css 'div.panel-left'
    end

    it 'renders the room action' do
      render_inline(described_class.new(user: member, variant: :left))

      expect(page).to have_css 'div.panel__actions>a[href="/rooms"]', text: 'R'
    end
  end

  context 'with right variant' do
    it 'renders component on right' do
      render_inline(described_class.new(user: member, variant: :right))

      expect(page).to have_css 'div.panel-right'
    end

    context 'when user is owner' do
      it 'renders the settings actions' do
        render_inline(described_class.new(user: owner, variant: :right, room: room))

        expect(page).to have_css "a[href=\"/rooms/#{room.id}/edit\"]", text: 'S'
      end
    end

    context 'when user is admin' do
      it 'renders the settings actions' do
        render_inline(described_class.new(user: admin, variant: :right, room: room))

        expect(page).to have_css "a[href=\"/rooms/#{room.id}/edit\"]", text: 'S'
      end
    end

    context 'when user is member' do
      it 'does not render the settings actions' do
        render_inline(described_class.new(user: member, variant: :right, room: room))

        expect(page).to_not have_css "a[href=\"/rooms/#{room.id}/edit\"]", text: 'S'
      end
    end
  end
end

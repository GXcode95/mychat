require 'rails_helper'

RSpec.describe UserListComponent, type: :component do
  let(:users_room) { create(:users_room) }

  it 'renders component' do
    args = {
      users_rooms: [users_room],
      title: 'Title',
      list_attributes: { id: 'list-id' },
      class: 'mt-10'
    }
    render_inline(described_class.new(**args))

    expect(page).to have_css 'div.mt-10'
    expect(page).to have_css 'h2', text: 'Title'
    expect(page).to have_css 'ul#list-id'
  end
end

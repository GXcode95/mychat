require 'rails_helper'

RSpec.describe MessageComponent, type: :component do
  let(:message) { create(:message) }

  context 'when editable is false' do
    it 'renders component with message content' do
      render_inline(described_class.new(message))
      expect(page).to have_css "div.msg--#{message.author.id}"
      expect(page).to have_css 'p.msg__content'
    end
  end

  context 'when editable is true' do
    it 'renders component with form' do
      render_inline(described_class.new(message, editable: true))

      expect(page).to have_css "div.msg--#{message.author.id}"
      expect(page).to have_css "form#edit_message_#{message.id}"
    end
  end
end

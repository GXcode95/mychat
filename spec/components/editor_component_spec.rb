require 'rails_helper'

RSpec.describe EditorComponent, type: :component do
  it 'renders component' do
    message = create(:message)
    render_inline(described_class.new(message))

    expect(page).to have_css 'div[data-controller="message-form"]'
  end
end

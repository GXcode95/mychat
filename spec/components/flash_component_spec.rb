require 'rails_helper'

RSpec.describe FlashComponent, type: :component do
  it 'renders component' do
    flash_message = 'This is a flash'
    flash = ActionDispatch::Flash::FlashHash.new
    flash[:error] = flash_message
    render_inline(described_class.new(flash))

    expect(page).to have_css 'div#flash'
    expect(page).to have_css '.flash--error', text: flash_message
  end
end

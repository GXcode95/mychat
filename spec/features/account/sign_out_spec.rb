require 'rails_helper'

RSpec.feature 'Sign out', type: :feature do
  let(:user) { create(:user) }

  RSpec.configure do |c|
    c.include FeaturesHelper
  end

  before do
    login(user)
  end

  scenario 'signs out' do
    visit rooms_path
    click_button 'Logout'

    expect(page).to have_current_path(new_user_session_path)
  end
end

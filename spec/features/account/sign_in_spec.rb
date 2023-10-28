require 'rails_helper'

RSpec.feature 'Sign in', type: :feature do
  let(:user) { create(:user) }

  scenario 'signs in' do
    visit new_user_session_path

    fill_in 'email', with: user.email
    fill_in 'password', with: user.password

    click_button 'Login'

    expect(page).to have_current_path(root_path)
  end
end

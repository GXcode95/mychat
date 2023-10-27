require 'rails_helper'

RSpec.feature 'Sign in', type: :feature do
  let(:user) { create(:user) }

  scenario 'signs in' do
    visit '/users/sign_in'

    fill_in 'email', with: user.email
    fill_in 'password', with: user.password

    click_button 'login'

    expect(page).to have_current_path(root_path)
  end
end

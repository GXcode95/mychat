require 'rails_helper'

RSpec.feature 'Sign up', type: :feature do
  scenario 'signs up' do
    visit new_user_registration_path

    fill_in 'email', with: 'user@mail.com'
    fill_in 'password', with: 'password'
    fill_in 'password confirmation', with: 'password'

    click_button 'Sign up'

    expect(page).to have_current_path(root_path)
    expect(User.all.size).to eq(1)
  end
end

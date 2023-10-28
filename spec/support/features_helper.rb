module FeaturesHelper
  def login(user)
    visit '/users/sign_in'

    fill_in 'email', with: user.email
    fill_in 'password', with: user.password

    click_button 'Login'
  end
end

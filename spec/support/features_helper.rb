module FeaturesHelper
  def login
    visit "/users/sign_in?locale=#{user.locale}"

    fill_in 'email', with: user.email
    fill_in 'password', with: user.password

    click_button 'login'
  end
end

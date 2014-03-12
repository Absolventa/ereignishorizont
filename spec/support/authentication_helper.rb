module AuthenticationHelper

  def log_in_user(user = nil)
    user ||= FactoryGirl.create(:user)
    visit '/'
    fill_in 'Email',    with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log In'
  end
end

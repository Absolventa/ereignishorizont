require 'rails_helper'

feature 'Authenticating users' do

  let(:user) { FactoryGirl.create(:user) }

  context 'As a signed up User' do
    scenario 'When I enter my credentials I am signed in' do
      visit '/'
      fill_in 'Email',    with: user.email
      fill_in 'Password', with: user.password
      click_on 'Log In'

      expect(current_path).to eq incoming_events_path
      expect(page).to have_content("Logged in!")
      expect(page).to have_content("Logged in as #{user.email}")
    end

    scenario 'When I am already signed in I want to be able to sign out' do
      log_in_user(user)

      click_on 'Account'
      click_on 'Log Out'

      expect(current_path).to eq login_path
    end

    scenario 'When I enter invalid credentials I am not signed in' do
      visit '/'
      fill_in 'Email',    with: user.email
      fill_in 'Password', with: 'oops...typo'
      click_on 'Log In'

      expect(current_path).to eq login_path
      expect(page).to have_content 'Not authorized'
    end
  end

  context 'As a not-signed-up User' do
    scenario 'I am not authorized to sign in' do
      visit '/'
      fill_in 'Email',    with: 'guest@not-signed-up.com'
      fill_in 'Password', with: 'not-signed-up'
      click_on 'Log In'

      expect(current_path).to eq login_path
      expect(page).to have_content 'Not authorized'
    end
  end
end

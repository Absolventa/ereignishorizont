require 'spec_helper'

feature 'Updating users' do
  given(:user) { User.create(email: 'me@example.com', password: 'secret', password_confirmation: 'secret') }

  background do
    # TODO refactor me into log_in_user-method support
    visit login_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log In'

    click_on 'Account'
    click_on 'Profile'
    click_on 'Edit'
  end

  context 'valid scenarios' do
    scenario 'submitting the form as is updates the user but changes nothing' do
      click_on 'Update User'
      expect(page).not_to have_content 'error'
    end

    scenario 'changing any attribute except password changes that attribute' do
      fill_in 'Email', with: 'my-new-email@example.com'
      click_on 'Update User'
      expect(page).not_to have_content 'error'
      expect(page).to have_content 'my-new-email@example.com'
    end

    scenario 'changing password_confirmation changes nothing' do
      fill_in 'Password confirmation', with: 'new'
      click_on 'Update User'
      expect(page).not_to have_content 'error'
    end
  end

  context 'invalid scenarios' do
    scenario 'changing password only shows validation error' do
      fill_in 'Password', with: 'new'
      click_on 'Update User'
      expect(page).to have_content 'error'
    end

    scenario 'changing password and password_confirmation but differently shows validation error' do
      fill_in 'Password', with: 'new'
      fill_in 'Password confirmation', with: 'different'
      click_on 'Update User'
      expect(page).to have_content 'error'
    end
  end
end

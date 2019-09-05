require 'rails_helper'

feature 'OmniOath' do
  scenario 'sings in user with facebook' do
    visit new_user_registration_path
    expect(page).to have_content("Sign in with Facebook")
    mock_auth_hash
    click_link "Sign in with Facebook"
    expect(page).to have_content("Mockuser")
    expect(User.find_by_email('mockuser@test.com').name).to eql('mockuser')
    expect(page).to_not have_current_path(new_user_session_path)
  end

  scenario 'sings in with invalid e-mail' do
    visit new_user_registration_path
    expect(page).to have_content("Sign in with Facebook")
    OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
    click_link "Sign in with Facebook"
    expect(page).to have_content('Sign up')
    expect(page).to_not have_current_path(root_path)
  end
end
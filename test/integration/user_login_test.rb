require 'test_helper'

class UserLoginTest < ActionDispatch::IntegrationTest
  include Capybara::DSL
  attr_reader :user

  def setup
    @user = User.create(username: 'user',
                      password: 'password',
                      first_name: 'John',
                      last_name: 'Doe',
                      email: 'example@example.com')
    visit root_url
  end

  test "user can login" do
    within ("#header") do
      assert page.has_content?('Coffee House')
    end
    fill_in 'session[username]', with: 'user'
    fill_in 'session[password]', with: 'password'
    click_link_or_button 'Login'
    assert current_path, root_url
    within ('#header') do
      assert page.has_content?('Welcome, John')
    end
  end

  test 'a user can logout' do
    fill_in 'session[username]', with: 'user'
    fill_in 'session[password]', with: 'password'
    click_link_or_button 'Login'
    click_link_or_button "Logout"
    within('#flash_notice') do
      assert page.has_content?("You have successfully logged out")
    end
  end
end

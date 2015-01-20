require 'test_helper'

class UserLoginTest < ActionDispatch::IntegrationTest
  include Capybara::DSL

  test "user can login" do
    user = User.create(username: 'user',
                       password: 'password',
                       first_name: 'John',
                       last_name: 'Doe',
                       email: 'example@example.com')
    visit root_url
    within ("#header") do
      assert page.has_content?('Coffee House')
    end
    fill_in 'session[username]', with: 'user'
    fill_in 'session[password]', with: 'password'
    click_link_or_button 'Login'
    assert current_path, root_url
    within ('#header') do
      assert page.has_content?('Weclome, User')
    end
  end
end

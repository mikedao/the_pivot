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
    assert page.has_content?('Cinema Coffee')

    fill_in 'session[username]', with: 'user'
    fill_in 'session[password]', with: 'password'
    click_link_or_button 'Login'
    assert current_path, root_url
    assert page.has_content?('Welcome, John')
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

  test 'a logged in user cannot go to admin dashboard' do
    user = create(:user)
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    visit admin_dashboard_path
    assert root_path, current_path
  end

  test 'a logged in user cannot go to admin items path' do
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    visit admin_items_path
    assert root_path, current_path
  end

  test 'a logged in user cannot go to category path' do
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    visit admin_categories_path
    assert root_path, current_path
  end

  test 'a logged in user cannot go to orders path' do
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    visit admin_orders_path
    assert root_path, current_path
  end

end

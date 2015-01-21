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

  test "user can view his order page" do
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    click_link_or_button 'Cart'
    assert current_path, cart_items_path
    click_link_or_button 'Order History'
    assert current_path, orders_path
    within ('#history') do
      assert page.has_content?('Pour Over')
    end
  end
end

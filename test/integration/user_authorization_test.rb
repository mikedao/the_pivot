require 'test_helper'

class UserAuthorizationTest < ActionDispatch::IntegrationTest
  include Capybara::DSL
  attr_reader :user

  def setup
    @user = User.create(username: 'user',
                        password: 'password',
                        first_name: 'John',
                        last_name: 'Doe',
                        email: 'example@example.com',
                        role: 1)
                        visit root_url
  end

  test "an unauthorized user cannot see another user's order history and only his own" do
    user = create(:user)
    user1 = create(:user)
    user1 = User.create(username: 'xxx',
                        password: 'yyy',
                        first_name: 'Jeff',
                        last_name: 'Wan',
                        email: 'examples@example.com',
                        role: 1)

    ApplicationController.any_instance.stubs(:current_user).returns(user)

    visit "/users/#{user1.id}/orders"
    assert page.has_content?("Nice Try")

    visit "/users/#{user.id}/orders"
    assert page.has_content?("Order History")
  end
end

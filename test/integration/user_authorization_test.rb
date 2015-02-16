require "test_helper"

class UserAuthorizationTest < ActionDispatch::IntegrationTest
  include Capybara::DSL
  attr_reader :user

  test "an unauthorized user cannot see another user's order history and
        only his own" do
    skip
    user = create(:user)
    user1 = create(:user)
    ApplicationController.any_instance.stubs(:current_user).returns(user)

    visit "/users/#{user1.id}/orders"
    assert_equal root_url, current_path

    visit "/users/#{user.id}/orders"
    assert page.has_content?("Order History")
  end
end

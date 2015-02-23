require "test_helper"

class UserAuthorizationTest < ActionDispatch::IntegrationTest
  include Capybara::DSL

  test "an unauthorized user cannot see another user's order history and
        only his own" do
    user = create(:user)
    user1 = create(:user, username: "Something", email: "blah@blah.com")
    ApplicationController.any_instance.stubs(:current_user).returns(user)

    visit "/users/#{user1.id}/orders"
    assert_equal root_path, current_path

    visit "/users/#{user.id}/orders"
    assert page.has_content?("Order History")
  end
end

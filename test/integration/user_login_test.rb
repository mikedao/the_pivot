require "test_helper"

class UserLoginTest < ActionDispatch::IntegrationTest
  include Capybara::DSL

  test "user can login" do
    user = create(:user)
    visit root_path

    fill_in "session[username]", with: user.username
    fill_in "session[password]", with: user.password
    click_link_or_button "Login"

    assert_equal root_path, current_path
    assert page.has_link?("Logout")
  end

  test "a user can logout" do
    user = create(:user)
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    visit root_path

    click_link_or_button "Logout"
    within(".flash-notice") do
      assert page.has_content?("You have successfully logged out")
    end
  end

  test "an authenticated user does not see the 'Login' or 'Signup'
  options in the _navbar" do
    authenticated_user = create(:user)
    ApplicationController.any_instance.stubs(:current_user).
      returns(authenticated_user)

    visit root_path

    assert page.has_content?("Logout")
    assert page.has_content?("Profile")
    refute page.has_content?("Signup")
    refute page.has_content?("Login")
  end

  test "an authenticated user can access their profile" do
    authenticated_user = create(:user)
    ApplicationController.any_instance.stubs(:current_user).
      returns(authenticated_user)

    visit root_path
    click_link_or_button "Profile"

    assert page.has_content?(authenticated_user.first_name)
    assert page.has_content?(authenticated_user.last_name)
    assert page.has_content?(authenticated_user.email)
    assert page.has_content?(authenticated_user.zipcode)
    assert page.has_content?(authenticated_user.street)
    assert page.has_content?(authenticated_user.city)
    assert page.has_content?(authenticated_user.state)
    assert page.has_content?(authenticated_user.zipcode)
  end

  test "a logged in user cannot go to admin dashboard" do
    user = create(:user)
    ApplicationController.any_instance.stubs(:current_user).returns(user)

    visit admin_dashboard_path

    assert root_path, current_path
  end

  test "a logged in user cannot go to category path" do
    user = create(:user)
    ApplicationController.any_instance.stubs(:current_user).returns(user)

    visit admin_categories_path

    assert root_path, current_path
  end
end

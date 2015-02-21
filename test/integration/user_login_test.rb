require "test_helper"

class UserLoginTest < ActionDispatch::IntegrationTest
  include Capybara::DSL
  attr_reader :user

  def setup
    @user = User.create(username: "user",
                        password: "password",
                        first_name: "John",
                        last_name: "Doe",
                        email: "example@example.com")
    visit root_url
  end

  test "user can login" do
    skip
    assert page.has_content?("Cinema Coffee")

    fill_in "session[username]", with: "user"
    fill_in "session[password]", with: "password"
    click_link_or_button "Login"
    assert_equal current_path, root_url
    assert page.has_content?("Welcome, John")
  end

  test "a user can logout" do
    skip
    fill_in "session[username]", with: "user"
    fill_in "session[password]", with: "password"
    click_link_or_button "Login"
    click_link_or_button "Logout"
    within("#flash_notice") do
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

  test "a logged in user cannot go to admin projects path" do
    skip
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    visit admin_projects_path
    assert root_path, current_path
  end

  test "a logged in user cannot go to category path" do
    skip
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    visit admin_categories_path
    assert root_path, current_path
  end

  test "a logged in user cannot go to orders path" do
    skip
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    visit admin_orders_path
    assert root_path, current_path
  end

  test "when a user logs in from pending loans, he gets redirected back to
  pending loans" do
    user = create(:user)
    project = create(:project, title: "A Water Purifier")

    visit category_path(project.categories.first.id)
    within(".row") do
      click_link_or_button("Lend")
    end
    log_in_user(user)

    assert_equal pending_loan_path, current_path
    assert page.has_content?("Welcome back, #{user.username}")
  end

  test "when an unauthenticated user selects a loan and logs in from pending
  loans, he gets redirected back to pending loans with the item in his cart." do
  user = create(:user)
  project = create(:project, title: "A Water Purifier")

  visit category_path(project.categories.first.id)
  within(".row") do
    click_link_or_button("Lend")
  end
  log_in_user(user)

  assert page.has_content?("A Water Purifier")
  end
end

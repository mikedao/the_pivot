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
    within("#flash-notice") do
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

  test "when a user logs in from pending loans, he gets redirected back to
  pending loans" do
    skip
    user = create(:user)
    project = create(:project, title: "A Water Purifier")
    project.tenant.update_attributes(active: true, approved: true)

    visit projects_path
    within(".row") do
      click_link_or_button("Lend $25")
    end
    log_in_user(user)

    assert_equal pending_loan_path, current_path
    assert page.has_content?("Welcome back, #{user.username}")
  end

  test "when an unauthenticated user selects a loan and logs in from pending
  loans, he gets redirected back to pending loans with the item in his cart." do
    skip
    user = create(:user)
    project = create(:project, title: "A Water Purifier")
    project.tenant.update_attributes(active: true, approved: true)

    visit projects_path
    within(".row") do
      click_link_or_button("Lend $25")
    end
    log_in_user(user)

    assert_equal pending_loan_path, current_path
    assert page.has_content?(project.title)
  end

  test "when an unauthenticated user selects a loan and tries to checkout and
  logs in from the signup page, he gets redirected back to pending_loan_show and
  not the signup page" do
    skip
    user = create(:user)
    project = create(:project, title: "A Water Purifier")
    project.tenant.update_attributes(active: true, approved: true)

    visit projects_path
    within(".row") do
      click_link_or_button("Lend $25")
    end
    click_link_or_button("Checkout")
    log_in_user(user)

    assert_equal pending_loan_path, current_path
    assert page.has_content?(project.title)
    refute page.has_content?("Signup Page")
  end

  test "when a new user selects a loan and tries to checkout and signups, he
  gets redirected back to the pending_loan_show page" do
    skip
    project = create(:project, title: "A Water Purifier")
    project.tenant.update_attributes(active: true, approved: true)

    visit projects_path
    within(".row") do
      click_link_or_button("Lend $25")
    end
    click_link_or_button("Checkout")
    fill_in "signup[username]",               with: "Jwan622"
    fill_in "signup[first_name]",             with: "Jeff"
    fill_in "signup[last_name]",              with: "Wan"
    fill_in "signup[street]",                 with: "31 Hillwood Court"
    fill_in "signup[city]",                   with: "New York City"
    fill_in "signup[state]",                  with: "NY"
    fill_in "signup[zipcode]",                with: "10305"
    fill_in "signup[country]",                with: "USA"
    fill_in "signup[password]",               with: "password"
    fill_in "signup[password_confirmation]",  with: "password"
    fill_in "signup[email]",                  with: "Jwan6221@yahoo.com"
    click_link_or_button "Create Account"

    assert_equal pending_loan_path, current_path
    assert page.has_content?(project.title)
    refute page.has_content?("Signup Page")
  end
end

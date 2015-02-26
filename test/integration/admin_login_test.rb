require "test_helper"

class AdminUserTest < ActionDispatch::IntegrationTest
  include Capybara::DSL

  test "an admin can log in and get to the dashboard" do
    create(:admin)

    visit root_path
    fill_in "session[username]", with: "admin"
    fill_in "session[password]", with: "password"
    click_link_or_button("Login")

    assert page.has_content?("Logout")
    refute page.has_content?("Login")
  end

  test "an admin when logging in, is brought to the platform dashboard" do
    create(:admin)

    visit root_path
    fill_in "session[username]", with: "admin"
    fill_in "session[password]", with: "password"
    click_link_or_button("Login")

    assert_equal admin_dashboard_path, current_path
  end

  test "a logged in admin does not have a lend button in the nav bar" do
    admin = create(:admin)
    ApplicationController.any_instance.stubs(:current_user).returns(admin)

    visit root_path

    refute page.has_link?("Lend")
  end

  test "an admin when logged in has an Admin Dashboard link" do
    admin = create(:admin)
    ApplicationController.any_instance.stubs(:current_user).returns(admin)

    visit root_path

    assert page.has_content?("Admin Dashboard")
  end

  test "an admin does not see a 'Profile' button in their navbar" do
    admin = create(:admin)
    ApplicationController.any_instance.stubs(:current_user).returns(admin)

    visit root_path

    refute page.has_content?("Profile")
  end

  test "an admin has an 'All Borrowers' link in their navbar that
  links to a table of all borrowers" do
    admin = create(:admin)
    tenant1 = create(:tenant)
    tenant2 = create(:tenant)
    ApplicationController.any_instance.stubs(:current_user).returns(admin)

    visit root_path
    click_link_or_button("Admin Dashboard")

    within (".navbar") do
      click_link_or_button("All Borrowers")
    end

    assert_equal admin_tenants_path, current_path
    assert page.has_content?("#{tenant2.organization}")
  end

  test "an admin can create a category" do
    admin = create(:admin)
    ApplicationController.any_instance.stubs(:current_user).returns(admin)
    visit root_path
    click_link_or_button("Admin Dashboard")
    click_link_or_button("Categories")
    fill_in "categories[name]", with: "Blah"
    click_link_or_button("Add Category")

    assert page.has_content?("Blah")
  end

  test "a category with the same name cannot be created" do
    admin = create(:admin)
    ApplicationController.any_instance.stubs(:current_user).returns(admin)
    visit root_path
    click_link_or_button("Admin Dashboard")
    click_link_or_button("Categories")
    fill_in "categories[name]", with: "Blah"
    click_link_or_button("Add Category")
    fill_in "categories[name]", with: "Blah"
    click_link_or_button("Add Category")

    assert page.has_content?("Please Try Again")
  end

  test "registered admin can go to the admin categories page" do
    admin = create(:admin)
    ApplicationController.any_instance.stubs(:current_user).returns(admin)
    visit root_path
    click_link_or_button("Admin Dashboard")
    click_link_or_button("Categories")

    assert_equal admin_categories_path, current_path
  end
end

require "test_helper"

class PlatformAdminTest < ActionDispatch::IntegrationTest
  test "registered admin can create category" do
    skip
    ApplicationController.any_instance.stubs(:current_user).returns(user_admin)
    visit admin_dashboard_path
    click_link_or_button "Category"
    fill_in "categories[name]", with: "Blah"
    click_link_or_button "Add Category"
    assert page.has_content?("Blah")
  end

  test "unregistered admin cannot see category" do
    skip
    ApplicationController.any_instance.stubs(:current_user).returns(user_user)
    visit projects_path
    refute page.has_content?("Create Category")
  end
end

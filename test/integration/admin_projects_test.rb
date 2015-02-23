require "test_helper"

class AdminProjectsTest < ActionDispatch::IntegrationTest
  include Capybara::DSL

  test "an admin has a projects link on the dashboard" do
    admin = create(:admin)
    ApplicationController.any_instance.stubs(:current_user).returns(admin)

    visit admin_dashboard_path

    assert page.has_link?("Projects")
  end

  test "an admin clicking on the projects link is brought to the
  projects dashboard" do
    admin = create(:admin)
    ApplicationController.any_instance.stubs(:current_user).returns(admin)

    visit admin_dashboard_path
    click_link_or_button("Projects")

    assert_equal admin_projects_path, current_path
  end

  test "an admin sees projects on the project dashboard" do
    admin = create(:admin)
    project = create(:project)
    ApplicationController.any_instance.stubs(:current_user).returns(admin)

    visit admin_projects_path

    assert page.has_content?(project.title)
  end
end

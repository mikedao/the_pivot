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

  test "an admin in the projects dashboard has a link to the edit project
  page" do
    admin = create(:admin)
    project = create(:project)
    ApplicationController.any_instance.stubs(:current_user).returns(admin)

    visit admin_projects_path

    assert page.has_link?(project.title)
  end

  test "an admin can click on a project in the dashboard and goes to the edit
  project page" do
    admin = create(:admin)
    project = create(:project, tenant_id: 1)
    tenant = create(:tenant, id: 1)
    ApplicationController.any_instance.stubs(:current_user).returns(admin)

    visit admin_projects_path
    click_link_or_button(project.title)

    assert edit_tenant_project_path(project, slug: tenant.slug)
  end
end

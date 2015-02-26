require "test_helper"

class TenantProjectsIndexTest < ActionDispatch::IntegrationTest
  include Capybara::DSL
  include FactoryGirl::Syntax::Methods

  test "the tenant projects index page renders with pagination" do
    skip
    authenticated_user = create(:user)
    ApplicationController.any_instance.stubs(:current_user).
      returns(authenticated_user)
    tenant = create(:tenant)
    15.times do
      tenant.projects << create(:project)
    end

    visit tenant_projects_path(slug: tenant.slug)

    assert page.has_content?("Previous")
    assert page.has_content?("Next")
  end

  test "the user can see the next 10 projects in the index
  by clicking the 'Next' link" do
    skip
    authenticated_user = create(:user)
    ApplicationController.any_instance.stubs(:current_user).
      returns(authenticated_user)
    tenant = create(:tenant)
    15.times do
      tenant.projects << create(:project)
    end

    visit tenant_projects_path(slug: tenant.slug)
    click_link_or_button("Next")

    assert "#{tenant_projects_path(slug: tenant.slug)}?page=2", current_path
  end

  test "the user can go back to the previous 10 projects in the index
  by clicking the 'Previous' link" do
    skip
    authenticated_user = create(:user)
    ApplicationController.any_instance.stubs(:current_user).
      returns(authenticated_user)
    tenant = create(:tenant)
    15.times do
      tenant.projects << create(:project)
    end

    visit tenant_projects_path(slug: tenant.slug)
    click_link_or_button("Next")
    click_link_or_button("Previous")

    assert "#{tenant_projects_path(slug: tenant.slug)}?page=1", current_path
    refute "#{tenant_projects_path(slug: tenant.slug)}?page=2", current_path
  end
end

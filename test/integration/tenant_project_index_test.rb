require "test_helper"

class TenantProjectIndexTest < ActionDispatch::IntegrationTest
  include Capybara::DSL
  include FactoryGirl::Syntax::Methods

  test "pagination renders on page" do
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

  test "when user clicks on 'Next' button they are taken to
  the next 10 projects in the index" do
    authenticated_user = create(:user)
    ApplicationController.any_instance.stubs(:current_user).
      returns(authenticated_user)
    tenant = create(:tenant)
    15.times do
      tenant.projects << create(:project)
    end

    visit tenant_projects_path(slug: tenant.slug)
    click_link_or_button("Next", match: :first)

    assert "#{tenant.slug}/projects?page=2", current_path
  end

  test "when user clicks on 'Previous' button they are taken back
  to the previous 10 projects" do
    authenticated_user = create(:user)
    ApplicationController.any_instance.stubs(:current_user).
      returns(authenticated_user)
    tenant = create(:tenant)
    15.times do
      tenant.projects << create(:project)
    end

    visit tenant_projects_path(slug: tenant.slug)
    click_link_or_button("Next", match: :first)
    click_link_or_button("Previous", match: :first)

    assert "#{tenant.slug}/projects?page=1", current_path
  end
end

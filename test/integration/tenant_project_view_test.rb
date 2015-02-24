require "test_helper"

class TenantProjectViewTest < ActionDispatch::IntegrationTest
  include Capybara::DSL
  include FactoryGirl::Syntax::Methods

  test "a user can view a tenant project page" do
    user = create(:user)
    project1 = create(:project)
    ApplicationController.any_instance.stubs(:current_user).returns(user)

    visit tenant_path(slug: project1.tenant.slug)

    project1.categories.each do |category|
      assert page.has_link?(category.name)
    end
  end

  test "The tenant project page has all the project details" do
    user = create(:user)
    project = create(:project)
    project.photos << create(:photo)
    ApplicationController.any_instance.stubs(:current_user).returns(user)

    visit tenant_project_path(slug: project.tenant.slug, id: project.id)

    assert page.has_content?(project.tenant.organization)
    assert page.has_content?(project.tenant.location)
    assert page.has_content?(project.title)
    assert page.has_content?(project.description)
    assert page.has_content?(project.price / 100)
    assert page.has_content?(project.categories.first.name)
    assert page.has_content?("Repayment Rate: #{project.repayment_rate}")
    assert page.has_content?("Requested by: #{project.requested_by}")
    assert page.has_content?("Repayment begins: #{project.repayment_begin}")
  end

  test "The tenant project page has a lend button" do
    project = create(:project)

    visit tenant_project_path(slug: project.tenant.slug, id: project.id)

    assert page.has_button?("Lend $25")
  end

  test "a user can go back to the projects page from the tenant project page" do
    project = create(:project)

    visit tenant_project_path(slug: project.tenant.slug, id: project.id)
    first(".project-category").
      click_link_or_button(project.categories.first.name)

    assert_equal projects_path, current_path
  end

  test "a guest user can add projects to pending_loans and see the
  projects on the pending_loans show page" do
    project = create(:project)
    tenant_slug = project.tenant.slug

    visit tenant_project_path(slug: tenant_slug, id: project.id)
    within("#lend-form") do
      click_link_or_button("Lend $25")
    end

    within("#pending_loans") do
      assert page.has_content?(project.title)
      assert page.has_content?("$25.00")
    end
  end
end

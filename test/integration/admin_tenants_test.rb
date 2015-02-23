require "test_helper"

class AdminUserTest < ActionDispatch::IntegrationTest
  include Capybara::DSL

  test "an admin sees a borrowers link in the dashboard" do
    admin = create(:admin)
    ApplicationController.any_instance.stubs(:current_user).returns(admin)

    visit admin_dashboard_path

    assert page.has_link?("All Borrowers")
  end

  test "an admin clicking on the borrowers link is brought to the tenants
  dashboard" do
    admin = create(:admin)
    ApplicationController.any_instance.stubs(:current_user).returns(admin)

    visit admin_dashboard_path
    click_link_or_button("All Borrowers")

    assert_equal admin_tenants_path, current_path
  end

  test "an admin can see tenants on the tenant dashboard" do
    admin = create(:admin)
    tenant = create(:tenant)
    ApplicationController.any_instance.stubs(:current_user).returns(admin)

    visit admin_tenants_path

    assert page.has_content?(tenant.organization)
  end

  test "an admin sees unapproved tenants in the right place" do
    admin = create(:admin)
    tenant = create(:tenant)
    ApplicationController.any_instance.stubs(:current_user).returns(admin)

    visit admin_tenants_path

    within("#unapproved") do
      assert page.has_content?(tenant.organization)
    end
  end

  test "an admin sees inactive tenants in the right place" do
    admin = create(:admin)
    tenant = create(:tenant)
    ApplicationController.any_instance.stubs(:current_user).returns(admin)

    visit admin_tenants_path

    within("#inactive") do
      assert page.has_content?(tenant.organization)
    end
  end

  test "an admin sees active tenants in the right place" do
    admin = create(:admin)
    tenant = create(:tenant, active: true, approved: true)
    ApplicationController.any_instance.stubs(:current_user).returns(admin)

    visit admin_tenants_path

    within("#active") do
      assert page.has_content?(tenant.organization)
    end
  end

  test "an admin can approve a tenant and it moves accordingly" do
    admin = create(:admin)
    tenant = create(:tenant)
    ApplicationController.any_instance.stubs(:current_user).returns(admin)

    visit admin_tenants_path
    within("#unapproved") do
      click_link_or_button("EDIT")
    end
    find(:css, "#approved_checkbox").set(true)
    click_link_or_button("Update Tenant")

    within("#inactive") do
      assert page.has_content?(tenant.organization)
    end
  end

  test "an admin can approve and active a tenant, and it moves accordingly" do
    admin = create(:admin)
    tenant = create(:tenant)
    ApplicationController.any_instance.stubs(:current_user).returns(admin)

    visit admin_tenants_path
    within("#unapproved") do
      click_link_or_button("EDIT")
    end
    find(:css, "#approved_checkbox").set(true)
    find(:css, "#active_checkbox").set(true)
    click_link_or_button("Update Tenant")

    within("#inactive") do
      assert page.has_content?(tenant.organization)
    end
  end

  test "an admin can make an active tenant inactive" do
    admin = create(:admin)
    tenant = create(:tenant, active: true, approved: true)
    ApplicationController.any_instance.stubs(:current_user).returns(admin)

    visit admin_tenants_path
    within("#active") do
      click_link_or_button("EDIT")
    end
    find(:css, "#active_checkbox").set(false)
    click_link_or_button("Update Tenant")

    within("#active") do
      assert page.has_content?(tenant.organization)
    end
  end

  test "the tenants admin dashboard page has a link to the tenant dashboard" do
    admin = create(:admin)
    tenant = create(:tenant)
    ApplicationController.any_instance.stubs(:current_user).returns(admin)

    visit admin_tenants_path

    assert page.has_link?(tenant.organization)
  end

  test "on the tenant admin dashboard, the organization name links to its
  dashboard" do
    admin = create(:admin)
    tenant = create(:tenant)
    ApplicationController.any_instance.stubs(:current_user).returns(admin)

    visit admin_tenants_path
    within("#unapproved") do
      click_link_or_button(tenant.organization)
    end

    assert tenant_dashboard_path(slug: tenant.slug), current_path
  end

  test "the tenants admin dashboard page has links in unapproved to tenant
  dashboard" do
    admin = create(:admin)
    tenant = create(:tenant)
    ApplicationController.any_instance.stubs(:current_user).returns(admin)

    visit admin_tenants_path

    within("#unapproved") do
      assert page.has_link?(tenant.organization)
    end
  end

  test "the tenants admin dashboard page has links in inactive to tenant
  dashboard" do
    admin = create(:admin)
    tenant = create(:tenant)
    ApplicationController.any_instance.stubs(:current_user).returns(admin)

    visit admin_tenants_path

    within("#inactive") do
      assert page.has_link?(tenant.organization)
    end
  end

  test "the tenants admin dashboard page has links in active to tenant
  dashboard" do
    admin = create(:admin)
    tenant = create(:tenant, approved: true, active: true)
    ApplicationController.any_instance.stubs(:current_user).returns(admin)

    visit admin_tenants_path

    within("#active") do
      assert page.has_link?(tenant.organization)
    end
  end
end

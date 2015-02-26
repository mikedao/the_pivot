require "test_helper"

class TenantViewTest < ActionDispatch::IntegrationTest
  include Capybara::DSL

  test "tenants that are not active are not displayed" do
    create(:tenant, approved: true)
    visit tenants_path

    refute page.has_content?("farm")
  end

  test "tenants that are not approved are not displayed" do
    create(:tenant, active: true)
    visit tenants_path

    refute page.has_content?("farm")
  end

  test "tenants that are not approved do not have a visible url" do
    tenant = create(:tenant, active: true)
    visit tenant_path(slug: tenant.slug)

    assert_equal root_path, current_path
  end
end

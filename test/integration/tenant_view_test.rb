require "test_helper"

class TenantViewTest < ActionDispatch::IntegrationTest
  include Capybara::DSL

  test "tenants index page displays tenants" do
    create(:tenant, active: true, approved: true)
    visit tenants_path

    assert page.has_content?("farm")
  end

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
end

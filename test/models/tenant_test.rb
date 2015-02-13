require "test_helper"

class TenantTest < ActiveSupport::TestCase
  test "tenant has attributes" do
    tenant = build(:tenant)

    assert tenant.valid?
  end

  test "tenant is not valid even without an orgnization" do
    tenant = build(:tenant, organization: nil)

    assert tenant.invalid?
  end

  test "tenant is not valid without a location" do
    tenant = build(:tenant, location: nil)

    assert tenant.invalid?
  end

  test "tenant slug is generated" do
    tenant = create(:tenant)

    assert_equal tenant.organization.parameterize, tenant.slug
  end
end

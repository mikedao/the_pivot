require "test_helper"

class TenantTest < ActiveSupport::TestCase
  test "tenant has attributes" do
    tenant = build(:tenant)

    assert tenant.valid?
  end

  test "tenant is not valid without an orgnization" do
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

  test "tenant is not valid with a too long or short organization" do
    invalid_tenants = [build(:tenant, organization: "a" * 3),
                       build(:tenant, organization: "a" * 256)]

    invalid_tenants.each do |tenant|
      assert tenant.invalid?
    end
  end

  test "tenant is not valid with a too long or short location" do
    invalid_tenants = [build(:tenant, location: "a" * 5),
                       build(:tenant, location: "a" * 256)]

    invalid_tenants.each do |tenant|
      assert tenant.invalid?
    end
  end

  test "tenant is not active by default" do
    tenant = create(:tenant)

    refute tenant.active?
  end

  test "tenant is not approved by default" do
    tenant = create(:tenant)

    refute tenant.approved?
  end

end

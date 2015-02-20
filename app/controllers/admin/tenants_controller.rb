class Admin::TenantsController < Admin::BaseController
  def index
    @tenants = Tenant.select(:organization, :location, :slug).all
  end
end

class Admin::TenantsController < Admin::BaseController

  def index
    @tenants = Tenant.all
  end
  
end

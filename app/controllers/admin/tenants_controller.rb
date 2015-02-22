class Admin::TenantsController < Admin::BaseController
  def index
    @tenants = Tenant.select(:organization, :location, :slug, :id).all
  end

  def edit
    @tenant = Tenant.find(tenant_id)
  end

  def update
    old_tenant = Tenant.find(tenant_id)
    puts "Tenant_id: #{tenant_id}"
    puts "Active? #{active?}"
    puts "Approved? #{approved?}"
    puts "Organization #{params_org}"
    puts "Location: #{params_loc}"

    tenant = Tenant.find(tenant_id)
    tenant.update(organization: params_org, location: params_loc,
                  active: active?
  end

  private

  def tenant_id
    params.require(:id)
  end

  def active?
    params[:tenant][:active] == 1
  end

  def approved?
    params[:tenant][:approved] == 1
  end

  def params_org
    params.require(:tenant).permit(:organization)[:organization]
  end

  def params_loc
    params.require(:tenant).permit(:location)[:location]
  end

end

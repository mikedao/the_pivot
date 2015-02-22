class Admin::TenantsController < Admin::BaseController
  def index
    @tenants = Tenant.select(:organization, :location, :slug, :id).all.
     order(:id)
  end

  def edit
    @tenant = Tenant.find(tenant_id)
  end

  def update

    tenant = Tenant.find(tenant_id)
    old_approved_status = tenant.approved
    tenant.update(organization: params_org, location: params_loc,
                  active: active?, approved: approved?)
    puts "old approved status: #{old_approved_status}"

    if old_approved_status == false && tenant.approved == true
      puts "THERE WAS A CHANGE"
    end
    redirect_to admin_tenants_path
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

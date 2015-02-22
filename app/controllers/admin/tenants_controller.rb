class Admin::TenantsController < Admin::BaseController
  def index
    @tenants = filtered_tenants
  end

  def edit
    @tenant = Tenant.find(tenant_id)
  end

  def update
    tenant = Tenant.find(tenant_id)
    old_approved_status = tenant.approved
    tenant.update(params_update)

    if old_approved_status == false && tenant.approved == true
      tenant.users.each do |user|
        UserMailer.approved_borrower(user, tenant).deliver_now
      end

    end
    redirect_to admin_tenants_path
  end

  private

  def tenant_id
    params.require(:id)
  end

  def params_update
    params.require(:tenant).permit(:organization, :location, :active, :approved)
  end

  def filtered_tenants
    result = []
    if Tenant.unapproved.present?
      result << Tenant.unapproved.select(:organization,
                                         :location,
                                         :slug,
                                         :id).all.order(:id)
    else
      result << nil
    end
    if Tenant.inactive.present?
      result << Tenant.inactive.select(:organization,
                                       :location,
                                       :slug,
                                       :id).all.order(:id)
    else
      result << nil
    end
    if Tenant.actives.present?
      result << Tenant.actives.select(:organization,
                                      :location,
                                      :slug,
                                      :id).all.order(:id)
    else
      result << nil
    end
  end
end

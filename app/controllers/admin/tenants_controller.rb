class Admin::TenantsController < Admin::BaseController
  def index
    if !Tenant.unapproved.empty?
      @unapproved = Tenant.unapproved.select(:organization,
                                             :location,
                                             :slug,
                                             :id).all.order(:id)
    else
      @unapproved = nil
    end

    if !Tenant.inactive.empty?
      @inactive = Tenant.inactive.select(:organization,
                                         :location,
                                         :slug,
                                         :id).all.order(:id)
    else
      @inactive = nil
    end

    if !Tenant.actives.empty?
      @actives = Tenant.actives.select(:organization,
                                       :location,
                                       :slug,
                                       :id).all.order(:id)
    else
      @actives = nil
    end
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
end

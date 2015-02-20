class TenantsController < ApplicationController
  def index
  end

  def show
  end

  def new
  end

  def create
    if Tenant.find_by(org_check)
      flash[:notice] = "Organization Already Exists"
      redirect_to new_tenant_path
    else
      create_tenant
    end
  end

  private

  def create_tenant
    tenant = Tenant.new(org_params)
    if tenant.save
      current_user.update_attribute(:tenant_id, tenant.id)
      redirect_to root_path
      flash[:notice] = "Organization Created."
    else
      flash[:notice] = "Please try again."
      redirect_to new_tenant_path
    end
  end

  def org_params
    params.require(:tenant_signup).permit(:location, :organization)
  end

  def org_check
    params.require(:tenant_signup).permit(:organization)
  end
end

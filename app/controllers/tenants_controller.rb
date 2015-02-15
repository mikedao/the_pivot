class TenantsController < ApplicationController
  def index
  end

  def show
  end

  def new
  end

  def create
    if tenant.find_by(organization: params[:tenant_signup][:organization])
      flash[:notice] = "Organization Already Exists"
      redirect_to new_tenant_path
    else
      tenant = @current_user.tenant.new(org_params)
      if tenant.valid?
        tenant.save
        redirect_to root_path
        flash[:notice] = "Organization Created."
      else
        flash[:notice] = "Please try again."
        redirect_to new_tenant_path
      end
    end

  end

  private

  def org_params
    params.require(:tenant_signup).permit(:location, :organization)
  end

end

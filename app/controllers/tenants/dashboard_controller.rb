class Tenants::DashboardController < ApplicationController
  before_action :require_borrower

  def show
    @tenant = Tenant.find_by(slug: params[:slug])
  end

  private

  def require_borrower
    redirect_to root_path unless  current_user && !current_user.admin? && current_user.borrower? &&
      current_user.tenant.slug == params[:slug]
  end
end

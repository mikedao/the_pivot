class Tenants::DashboardController < ApplicationController
  def show
    @tenant = Tenant.find_by(slug: params[:slug])
  end
end

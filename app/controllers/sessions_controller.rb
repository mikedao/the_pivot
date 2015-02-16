class SessionsController < ApplicationController
  def create
    user = User.find_by(username: params[:session][:username])
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      flash[:notice] = "Welcome back!"
      redirect_lender_or_borrower(user)
    else
      flash[:errors] = 'Invalid Login'
      redirect_to root_url
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "You have successfully logged out"
    redirect_to root_url
  end

  private

  def redirect_lender_or_borrower(user)
    if user.lender?
      redirect_to root_url
    else
      redirect_to tenant_dashboard_path(slug: user.tenant.slug)
    end
  end
end

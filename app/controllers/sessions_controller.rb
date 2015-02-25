class SessionsController < ApplicationController
  def create
    if Admin.find_by(session_username)
      authenticate_admin(Admin.find_by(session_username))
    else
      store_location
      authenticate_user(User.find_by(session_username))
    end
  end

  def destroy
    reset_session
    flash[:notice] = "You have successfully logged out"
    redirect_to root_path
  end

  private

  def authenticate_admin(admin)
    if Admin.find_by(session_username).authenticate(session_password)
      session[:user_id] = admin.id
      session[:admin] = true
      flash[:notice] = "Welcome back, Admin."
      redirect_to admin_dashboard_path
    else
      invalid_login
    end
  end

  def authenticate_user(user)
    if user && user.authenticate(session_password)
      session[:user_id] = user.id
      flash[:notice] = "Welcome back, #{user.username}"
      redirect_lender_or_borrower(user)
    else
      invalid_login
    end
  end

  def invalid_login
    flash[:error] = "Invalid Login"
    redirect_to root_path
  end

  def session_username
    params.require(:session).permit(:username)
  end

  def session_password
    params.require(:session).permit(:password)[:password]
  end

  def redirect_lender_or_borrower(user)
    if user.lender?
      redirect_back_or(root_path)
    else
      redirect_to tenant_dashboard_path(slug: user.tenant.slug)
    end
  end
end

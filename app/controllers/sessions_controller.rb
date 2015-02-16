class SessionsController < ApplicationController
  def create
    if Admin.find_by(session_username)
      authenticate_admin(Admin.find_by(session_username))
    else
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
      redirect_to root_path
    else
      invalid_login
    end
  end

  def invalid_login
      flash[:errors] = "Invalid Login"
      redirect_to root_path
  end

  def session_username
    params.require(:session).permit(:username)
  end

  def session_password
    params.require(:session).permit(:password)[:password]
  end

  def is_an_admin?
    Admin.find_by(session_username)
  end

  def is_a_user?
    User.find_by(session_username)
  end
end

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  def current_user
    if session[:admin]
      @current_user ||= Admin.find(session[:user_id]) if session[:user_id]
    else
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
  end
  helper_method :current_user

  def authorize
    redirect_to login_path if current_user.nil?
  end
end

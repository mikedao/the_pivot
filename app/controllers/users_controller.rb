class UsersController < ApplicationController
  def new

  end

  def create
    if User.find_by(email: params[:signup][:email])
      flash[:notice] = "Account Already Exists"
      redirect_to new_user_path
    else
      user = User.create(user_params)
      session[:user_id] = user.id
      redirect_to root_url
    end
  end

  private

  def user_params
    params.require(:signup).permit(:username, :password, :first_name, :last_name, :email)
  end
end

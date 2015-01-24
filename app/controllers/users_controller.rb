class UsersController < ApplicationController
  def new

  end

  def create
    if User.find_by(email: params[:signup][:email])
      flash[:notice] = "Account Already Exists"
      redirect_to new_user_path
    else
      user = User.create(username: params[:signup][:username],
                         password: params[:signup][:password],
                         first_name: params[:signup][:first_name],
                         last_name: params[:signup][:last_name],
                         email: params[:signup][:email],
                         role: 0)
      session[:user_id] = user.id
      redirect_to root_url
    end
  end
end

class UsersController < ApplicationController
  def new
  end

  def create
    if User.find_by(email: params[:signup][:email])
      flash[:notice] = "Account Already Exists"
      redirect_to new_user_path
    else
      user = User.new(user_params)
      user.tenant_id = session[:tenant_id]
      if user.valid?
        user.save
        session[:user_id] = user.id
        flash[:notice] = "Thank you for creating an account."
        redirect_to root_path
      else
        flash[:notice] = "Please try again."
        redirect_to new_user_path
      end
    end
  end

  private

  def user_params
    params.require(:signup).permit(:username,
                                   :password,
                                   :password_confirmation,
                                   :first_name,
                                   :last_name,
                                   :street,
                                   :city,
                                   :state,
                                   :zipcode,
                                   :country,
                                   :email
                                  )
  end

  def borrower?
    params.require(:signup).permit(:borrower)[:borrower] == "1"
  end

end

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
        create_user(user)
      else
        flash[:notice] = "Please try again."
        redirect_to new_user_path
      end
    end
  end

  private

  def create_user(user)
    user.save
    session[:user_id] = user.id
    send_welcome_email(user)
    flash[:notice] = "Thank you for creating an account."
    redirect_to root_path
  end

  def send_welcome_email(user)
    UserMailer.welcome_borrower(user).deliver_now if user.borrower?
    UserMailer.welcome_lender(user).deliver_now if user.lender?
  end

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
end

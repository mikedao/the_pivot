class UsersController < ApplicationController
  def new
  end

  def create
    if User.find_by(new_email)
      duplicate_email
    else
      user = User.new(user_params)
      user.tenant_id = session[:tenant_id]
      if user.valid?
        create_user(user)
      else
        invalid_user
      end
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private

  def duplicate_email
    flash[:notice] = "Account Already Exists"
    redirect_to new_user_path
  end

  def new_email
    params.require(:signup).permit(:email)
  end

  def invalid_user
    flash[:notice] = "Please try again."
    redirect_to new_user_path
  end

  def create_user(user)
    user.save
    session[:user_id] = user.id
    puts "AM I A TENANT? #{tenant?}"
    send_welcome_email(user)
    flash[:notice] = "Thank you for creating an account."
    if tenant?
      redirect_to new_tenant_path
    else
      redirect_to root_path
    end
  end

  def send_welcome_email(user)
    UserMailer.welcome_borrower(user).deliver_now if user.borrower?
    UserMailer.welcome_lender(user).deliver_now if user.lender?
  end

  def tenant?
    params[:signup][:tenant] == 1
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

class OrdersController < ApplicationController

  def index
    if current_user && current_user.id == params[:user_id].to_i
      @user = User.find(params[:user_id])
      render :index
    else
      redirect_to root_path
    end
  end

  def show
    @order = Order.find(params[:id])
    if order_owner_or_admin?
      @order
    else
      redirect_to root_path
    end
  end

  def new
  end

  def create
    if current_user.nil?
      flash[:alert] = "You Must Login or Signup to Lend Money"
      redirect_to pending_loan_path
    else
      pending_loans = PendingLoan.new(session[:pending_loan])
      if pending_loans.valid?
        @order = pending_loans.checkout!(session[:user_id])
      else
        flash[:alert] = "You have no pending loans. Please select a loan to checkout."
        redirect_to projects_path
      end
      session.delete(:pending_loan)
      flash[:notice] = "You have successfully completed your loans."
      redirect_to user_order_path(user_id: session[:user_id], id: @order.id)
    end
  end

  private

  def order_owner_or_admin?
    current_user && (current_user.id == @order.user_id || current_user.admin?)
  end
end

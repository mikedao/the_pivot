class OrdersController < ApplicationController
x
  def index
    if current_user && current_user.id == params[:user_id].to_i
      @user = User.find(order_params[:user_id])
      render :index
    else
      redirect_to root_path
    end
  end

  def show
    @order = Order.find(order_params[:id])
    if order_owner_or_admin?
      @order
    else
      redirect_to root_path
    end
  end

  def new
  end

  def create
    pending_loans = PendingLoan.new(session[:pending_loan])
    if pending_loans.present?
      complete_loan(pending_loans)
    else
      flash[:alert] = "You have no pending loans. " +
                      "Please select a loan to checkout."
      redirect_to projects_path
    end
  end

  private

  def order_params
    params.permit(:id, :user_id)
  end

  def order_owner_or_admin?
    current_user && (current_user.id == @order.user_id || current_user.admin?)
  end

  def complete_loan(pending_loans)
    @order = pending_loans.checkout!(session[:user_id])
    session.delete(:pending_loan)
    flash[:notice] = "You have successfully completed your loans."
    redirect_to user_order_path(user_id: session[:user_id], id: @order.id)
  end
end

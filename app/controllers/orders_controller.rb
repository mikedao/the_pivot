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
    pending_loans = PendingLoan.new(session[:pending_loan])
    total_cost = 0
    pending_loans.projects.each do |project, loan_amount|
      total_cost += project.price * loan_amount
    end
    @order = Order.create(
        total_cost: total_cost,
        user_id: session[:user_id],
        status: "completed")
    pending_loans.projects.each do |project, _loan_amount|
      Loan.new(
        project_id: project.id,
        order_id: @order.id
        )
    end
    session.delete(:pending_loan)
    redirect_to user_order_path(user_id: session[:user_id], id: @order.id)
  end

  def update_project_quantity
    session[:cart][params[:update_project_quantity][:project_id]] =
      params[:update_project_quantity][:quantity]
    flash[:notice] = "Project quantity updated"
  end

  private

  def order_owner_or_admin?
    current_user && (current_user.id == @order.user_id || current_user.admin?)
  end
end

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
    cart = Cart.new(session[:cart])
    total_cost = 0
    cart.projects.each do |project, quantity|
      total_cost += project.price * quantity.to_i
    end
    @order = Order.create(
      user_id: session[:user_id],
      total_cost: total_cost,
      status: 'ordered'
      )
    cart.projects.each do |project, quantity|
      Loan.create(
        project_id: project.id,
        order_id: @order.id,
        quantity: quantity,
        line_item_cost: project.price * quantity.to_i
        )
    end
    session.delete(:cart)
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

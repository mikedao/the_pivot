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
    cart.items.each do |item, quantity|
      total_cost += item.price * quantity.to_i
    end
    @order = Order.create(
      user_id: session[:user_id],
      total_cost: total_cost,
      status: 'ordered'
      )
    cart.items.each do |item, quantity|
      ItemOrder.create(
        item_id: item.id,
        order_id: @order.id,
        quantity: quantity,
        line_item_cost: item.price * quantity.to_i
        )
    end
    session.delete(:cart)
    redirect_to user_order_path(user_id: session[:user_id], id: @order.id)
  end

  private

  def order_owner_or_admin?
    current_user && (current_user.id == @order.user_id || current_user.admin?)
  end
end

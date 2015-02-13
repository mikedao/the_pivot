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
  end

  private

  def order_owner_or_admin?
    current_user && (current_user.id == @order.user_id || current_user.admin?)
  end
end

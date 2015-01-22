class OrdersController < ApplicationController
  def index
    @user = User.find(current_user.id)
  end

  def show
    @order = Order.find(params[:id])
  end
end

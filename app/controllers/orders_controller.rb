class OrdersController < ApplicationController
  def index
    authorize!(:read, current_user)
    @user = User.find(current_user.id)
  end

  def show
    @order = Order.find(params[:id])
  end

  def create

  end
end

class Admin::OrdersController < Admin::BaseController
  def index
    @users = User.all
  end

  def update
    order = Order.find(params[:id])
    order.update(status: params[:update_order_status]["status_#{order.id}"])
    redirect_to admin_orders_url
  end
end

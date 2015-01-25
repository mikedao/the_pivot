class OrdersController < ApplicationController

  def index

    if current_user.id == params[:user_id].to_i
      @user = User.find(params[:user_id])
      render :index
    else
      flash[:alert] = "Nice Try"
      redirect_to root_path
    end

    # @order = Order.new
    # authorize!(:read, @order)
  end

  def show
    @order = Order.find(params[:id])
  end

  def create

  end
end

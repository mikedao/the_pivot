class Admin::OrdersController < Admin::BaseController
  def index
    @users = User.all
  end
end

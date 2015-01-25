class Admin::ItemsController < Admin::BaseController

  def index
    @items = Item.all
    @item = Item.new
  end

  def edit
    @item = Item.find(params[:id])
  end

  def destroy
    @item = Item.find(params[:id])
    @item.destroy
    redirect_to admin_items_path
  end
end

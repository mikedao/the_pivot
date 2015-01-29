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

  def update
    item = Item.find(params[:id])
    item.update(retired: params[:retire]["status_#{item.id}"])
    redirect_to admin_items_path
  end

  def show
    @item = Item.find(params[:id])
    @item.destroy
    redirect_to admin_items_path
  end
end

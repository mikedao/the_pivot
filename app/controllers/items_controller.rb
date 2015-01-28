class ItemsController < ApplicationController
  include ItemsHelper

  def index
    if params[:category_name] == 'Shop All' || params[:category_name].nil?
      @items = Item.active
    else
      @items = Category.find_by(name: params[:category_name]).items
    end
      @categories = Category.all
  end

  def show
    @item = Item.find(params[:id])
  end

  def create
    @item = Item.create(item_params)
    add_category(params[:item][:categories])
    redirect_to items_path
  end

  def update
    @item = Item.find(params[:id])
    @item.update(item_params)
    redirect_to admin_items_path
  end

  private

  def item_params
    params.require(:item).permit(:title, :price, :description, :image)
  end
end

class ItemsController < ApplicationController
  def index
    if params[:category_name] == 'Shop All'
      @items = Item.all
    else
      @items = Category.find_by(name: params[:category_name]).items
    end
    @categories = Category.all
  end

  def show
    @item = Item.find(params[:id])
  end

  def edit
    @item = Item.find(params[:id])
  end

end

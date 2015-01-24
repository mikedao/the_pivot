class ItemsController < ApplicationController
  def index
    if params[:category_name]
      @items = Category.find_by(name: params[:category_name]).items
    else
      @items = Item.all
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

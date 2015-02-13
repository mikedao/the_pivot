class ItemsController < ApplicationController
  def index
    @items = Item.all
    @categories = Category.all
  end

  def show
    @item = Item.find_by(id: params[:id])
    @categories = Category.all
  end
end

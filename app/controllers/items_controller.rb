class ItemsController < ApplicationController
  def index
    if params[:category_name]
      category = Category.find_by(name: params[:category_name])
      @items = category.items
      @categories = []
    else
      @items = Item.all
      @categories = Category.all
    end
  end
end

class CategoriesController < ApplicationController

  def create
    Category.create(name: params[:categories][:name],
                    image: choose_icon)
    redirect_to items_path
  end

  private

  def choose_icon
    icon = icons.shuffle.pop
    params[:image] = icon
  end

  def icons
    ['fa fa-crosshairs', "fa fa-anchor", "fa fa-bolt", "fa fa-connectdevelop",
     "fa fa-beer", "fa fa-cloud", "fa fa-diamond", "fa fa-fire", "fa fa-life-ring",
     "fa fa-spoon"]
  end
end

class CategoriesController < ApplicationController

  def create
    Category.create(category_params)
    redirect_to items_path
  end

  private

  def category_params
    params.require(:categories).permit(:name, :image)
  end
end

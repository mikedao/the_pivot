class CategoriesController < ApplicationController
  def index
    @projects = Project.all.reject(&:retired)
    @categories = @projects.map(&:categories).flatten.uniq
  end

  def show
    @category = Category.find_by(id: params[:id])
    @projects = @category.projects
  end
end

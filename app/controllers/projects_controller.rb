class ProjectsController < ApplicationController
  def index
    @projects = Project.includes(:categories).active
    @categories = Category.select(:name).all

    if request.xhr?
      render json: @projects
    end
  end
end

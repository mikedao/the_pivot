class ProjectsController < ApplicationController
  def index
    @projects = Project.includes(:categories, :tenant).active
    @categories = Category.select(:name).all

    if request.xhr?
      render json: @projects
    end
  end

  private

  def all_projects
    Project.includes(:categories).active.joins(:tenant)
  end
end

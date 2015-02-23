class ProjectsController < ApplicationController
  def index
    @projects = Project.includes(:categories).active
    @categories = Category.select(:name).all

    if request.xhr?
      @all_projects = @projects.map do |project|
        project_categories = project.categories.map do |category|
          category.name.downcase
        end
        [project, project_categories]
      end
      render json: @all_projects
    end
  end
end

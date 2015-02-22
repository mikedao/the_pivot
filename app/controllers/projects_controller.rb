class ProjectsController < ApplicationController
  def index
    @projects = Project.includes(:categories).active
    @categories = Category.select(:name).all
    @locations = @projects.map do |project|
      project.tenant.location
    end.uniq

    if request.xhr? # XMLHttpRequest
      @all_projects = @projects.map do |project|
        [project, project.categories]
      end
      render json: @all_projects
    end
  end
end

class ProjectsController < ApplicationController
  def index
    @projects = Project.includes(:categories).active
    @categories = Category.select(:name).all

    if request.xhr?
      @all_projects = @projects.map do |project|
        project_hash = project.attributes
        project_hash["categories"] = project.categories.map(&:attributes)
        project_hash
      end

      render json: @all_projects
    end
  end
end

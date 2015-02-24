class ProjectsController < ApplicationController
  def index
    @projects = Project.includes(:categories).active
    @categories = Category.select(:name).all

    if request.xhr?
<<<<<<< HEAD
      @all_projects = @projects.map do |project|
        project_hash = project.attributes
        project_hash["categories"] = project.categories.map(&:attributes)
        project_hash
      end

      render json: @all_projects
=======
      render json: @projects
>>>>>>> e52edd60c7cf2aaaf728dd510da0db100fe68fde
    end
  end
end

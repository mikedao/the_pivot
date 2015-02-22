class ProjectsController < ApplicationController
  def index
    @projects = Project.includes(:categories).active
    @categories = Category.select(:name).all
    @locations = @projects.map do |project|
      project.tenant.location
    end.uniq
  end
end

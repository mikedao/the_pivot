class ProjectsController < ApplicationController
  def index
    @projects = Project.all.reject(&:retired)
    @categories = Category.all
  end
end

class ProjectsController < ApplicationController
  def index
    @projects = Project.all
    @categories = Category.all
  end

  def show
    @project = Project.find_by(id: params[:id])
    @categories = Category.all
  end
end

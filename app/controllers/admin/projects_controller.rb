class Admin::ProjectsController < Admin::BaseController
  def index
    @project = Project.new
    @projects = Project.all
  end
end

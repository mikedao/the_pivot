class Admin::ProjectsController < Admin::BaseController

  def index
    @projects = Project.all
    @project = Project.new
  end

  def edit
    @project = Project.find(params[:id])
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy
    redirect_to admin_projects_path
  end

  def update
    project = Project.find(params[:id])
    project.update(retired: params[:retire]["status_#{project.id}"])
    redirect_to admin_projects_path
  end

  def show
    @project = Project.find(params[:id])
    @project.destroy
    redirect_to admin_projects_path
  end
end

class Tenants::ProjectsController < ApplicationController
  include ProjectsHelper

  def index
    @tenant = Tenant.find_by(slug: params[:slug])

    redirect_to root_path if @tenant.nil?

    if params[:category_name] == "Shop All" || params[:category_name].nil?
      @projects = Project.active
    else
      @projects = Category.find_by(name: params[:category_name]).projects
    end
    @categories = Category.all
  end

  def show
    @project = Project.find(params[:id])
  end

  def create
    @project = Project.create(project_params)
    add_category(params[:project][:categories])
    redirect_to projects_path
  end

  def update
    @project = Project.find(params[:id])
    @project.update(project_params)
    redirect_to admin_projects_path
  end

  private

  def project_params
    params.require(:project).permit(:title, :price, :description,
                                    :retired, :tenant_id, :repayment_begin,
                                    :repayment_rate)
  end
end

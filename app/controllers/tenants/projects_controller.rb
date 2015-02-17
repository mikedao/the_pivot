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
    @project = Project.create!(title: project_params[:title],
                               description: project_params[:description],
                               price: project_params[:price],
                               tenant_id: current_user.tenant_id,
                               categories: new_categories)
    redirect_to tenant_dashboard_path
  end

  def update
    @project = Project.find(params[:id])
    @project.update_attributes!(title: project_params[:title],
                                description: project_params[:description],
                                price: project_params[:price],
                                tenant_id: current_user.tenant_id,
                                categories: new_categories)
    redirect_to tenant_dashboard_path
  end

  def new
    @project = Project.new
  end

  def edit
    @project = Project.find(params[:id])
  end

  private

  def project_params
    params.require(:project).permit(:title, :price, :description,
                                    :retired, :tenant_id, :repayment_begin,
                                    :repayment_rate, categories: [])
  end

  def new_category_ids
    cats = params.require(:project).permit(categories: [])
    cats[:categories].shift
    cats[:categories]
  end

  def new_categories
    categories = new_category_ids.map do |category|
      Category.find(category)
    end
    categories
  end
end

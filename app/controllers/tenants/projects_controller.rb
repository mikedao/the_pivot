class Tenants::ProjectsController < ApplicationController
  include ProjectsHelper

  def index
    @tenant = Tenant.find_by(slug: params[:slug])
    redirect_to root_path if @tenant.nil?

    if params[:category_name] == "Shop All" || params[:category_name].nil?
      @projects = Project.paginate(page: params[:page])
    else
      @projects = Category.find_by(name: params[:category_name]).projects
    end
    @categories = Category.all
  end

  def show
    @project = Project.find(params[:id])
  end

  def create
    @project = Project.create!(new_params)
    redirect_to tenant_dashboard_path
  end

  def update
    @project = Project.find(params[:id])
    if @project.update_attributes(new_params)
      flash[:notice] = "#{@project.title} Updated"
    else
      flash[:errors] = "Invalid Attributes"
    end
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
                                    :requested_by,
                                    :retired, :tenant_id, :repayment_begin,
                                    :repayment_rate, categories: [])
  end

  def new_category_ids
    cats = params.require(:project).permit(categories: [])
    cats[:categories].reject(&:blank?)
  end

  def new_categories
    categories = new_category_ids.map do |category|
      Category.find(category)
    end
    categories
  end

  def new_params
    new_param = project_params
    new_param[:categories] = new_categories
    new_param[:tenant_id] = current_user.tenant.id
    new_param
  end
end

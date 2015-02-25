class Tenants::ProjectsController < ApplicationController

  def index
    @tenant = Tenant.where(slug: params[:slug]).
                     where(active: true).
                     where(approved: true).first

    redirect_to root_path if @tenant.nil?

    if params[:category_name] == "Shop All" || params[:category_name].nil?
      @projects = Project.includes(:photos).active
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
      if session[:admin]
        redirect_to admin_projects_path
      else
        redirect_to tenant_dashboard_path
      end
    else
      if new_params[:categories].empty?
        flash[:errors] = "Please select one or more categories"
      else
        flash[:errors] = "Invalid Attributes"
      end
      redirect_to edit_tenant_project_path(@project, slug: @project.tenant.id)
    end
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
                                    # photos: {image: [:image_file_name, :image_content_type]}
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
    if current_user.nil?
      new_param[:tenant_id] = @project.tenant.id
    else
      if current_user.admin?
        new_param[:tenant_id] = @project.tenant.id
      else
        new_param[:tenant_id] = current_user.tenant_id
      end
    end
    new_param
  end
end

class ProjectsController < ApplicationController
  def index
    @projects = Project.all
    @categories = Category.all
  end

  def show
    @project = Project.find_by(id: params[:id])
    @categories = Category.all
  end

  def new
    @project = Project.new
  end

  def edit
    @project = Project.find(params[:id])
  end

  def create
    @project = Project.new(title: project_params[:title],
                           description: project_params[:description],
                           price: project_params[:price],
                           tenant_id: current_user.tenant_id)
    params[:project][:categories].shift
    categories = params[:project][:categories]
    categories.each do |category|
      @project.categories << Category.find(category)
    end

    @project.save!
    # binding.pry
    redirect_to tenant_dashboard_path(slug: @project.tenant.slug)
  end

  def update
    @project = Project.find(params[:id])
    @project.categories = []
    params[:project][:categories].shift
    categories = params[:project][:categories]
    new_categories = categories.map do |category|
      Category.find(category)
    end
    @project.update(title: project_params[:title],
                    description: project_params[:description],
                    price: project_params[:price],
                    tenant_id: current_user.tenant_id,
                    categories: new_categories)
    redirect_to tenant_dashboard_path(slug: @project.tenant.slug)
  end

  private

  def project_params
    params.require(:project).permit(:title, :description, :price,
                                    categories: [])
  end

  def find_categories
  end
end

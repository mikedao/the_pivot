class ProjectsController < ApplicationController
  def index
    @projects = all_projects.select do |project|
      project.tenant.visible_to_lenders == true &&
      project.current_amount_needed > 0
    end
    @categories = Category.all
  end

  private

  def all_projects
    Project.paginate(page: params[:page],
                     per_page: 10)
                    .includes(:categories).active.joins(:tenant)
  end
end

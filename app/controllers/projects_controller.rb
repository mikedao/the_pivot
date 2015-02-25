class ProjectsController < ApplicationController
  def index
    @projects = all_projects.select do |project|
      project.tenant.visible_to_lenders == true &&
      project.current_amount_needed > 0
    end
    @categories = Category.select(:name).all

    if request.xhr?
      require 'pry' ; binding.pry
      render json: @projects
    end
  end

  private

  def all_projects
    Project.includes(:categories).active.includes(:tenant)
  end
end

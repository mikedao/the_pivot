class WelcomeController < ApplicationController
  def index
    @projects = Project.includes(:categories).active
    @categories = @projects.map(&:categories).flatten.uniq
  end
end

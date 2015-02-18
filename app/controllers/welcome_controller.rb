class WelcomeController < ApplicationController
  def index
    @projects = Project.all.reject(&:retired)
    @categories = @projects.map(&:categories).flatten.uniq
  end
end

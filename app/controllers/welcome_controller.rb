class WelcomeController < ApplicationController
  def index
    @projects = Project.all.reject(&:retired)
    binding.pry
    @categories = Category.all
  end
end

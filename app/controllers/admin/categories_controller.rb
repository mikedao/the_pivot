class Admin::CategoriesController < Admin::BaseController

  def index
    @categories = Category.paginate(page: params[:page]).all
  end

  def create
    @category = Category.new(category_params)
    if @category.valid?
      category_create
    else
      invalid_category
    end
  end

  private

  def category_params
    params.require(:categories).permit(:name)
  end

  def category_create
    @category.save
    flash[:notice] = "Category Created"
    redirect_to admin_categories_path
  end

  def invalid_category
    flash[:errors] = "Please Try Again"
    redirect_to admin_categories_path
  end
end

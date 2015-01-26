class Presenter

  attr_reader :items, :categories
  
  def initialize
    @items = Item.all
    @categories = Category.all
  end

  def unique_category_names
    Category.all.each do |category|
      category.name
    end.uniq
  end
end

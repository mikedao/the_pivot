module ItemsHelper
  def add_category(categories)
    categories.map do |category_id|
      Category.find_by(:id => category_id)
    end.compact.each do |category|
      @item.categories << category
    end
  end
end

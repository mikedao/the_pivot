require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  attr_reader :item

  test "it is valid" do
    item = build(:item)
    item.categories << create(:category)
    assert item.valid?
  end

  test "it cannot have an empty string as a title" do
    category = Category.create(name: "hot beverages")
    item = category.items.create(title: '', description: "this is black gold", price: 30000)
    assert item.invalid?
  end

  test "it cannot have an empty string as a description" do
    category = Category.create(name: "hot beverages")

    item = category.items.create(title: 'espresso', description: "", price: 30000)
    assert item.invalid?
  end

  test "it cannot have a duplicate title" do
    category = create(:category)
    create(:item, title: "espresso", categories: [category])
    invalid_item = build(:item, title: "espresso", categories: [category])

    assert invalid_item.invalid?
  end

  test "it has a valid price" do
    category = create(:category, name: "hot beverages")
    item1 = create(:item, categories:[category], price: 40004)
    invalid_item1 = build(:item, categories:[category], price: 400.04)
    invalid_item2 = build(:item, categories:[category], price: "dasj")
    invalid_item3 = build(:item, categories:[category], price: "4%" )
    invalid_item4 = build(:item, categories:[category], price: -4)
    invalid_item5 = build(:item, categories:[category], price: 4000000)

    assert item1.valid?
    refute invalid_item1.valid?
    refute invalid_item2.valid?
    refute invalid_item3.valid?
    refute invalid_item4.valid?
    refute invalid_item5.valid?
  end

  test "it must have at least one category" do
    item = build(:item, categories: [])
    assert item.invalid?
  end

  test "it can have multiple categories" do
    categories = []
    1.upto(3) do |i|
      categories << create(:category, name: "Bad Category#{i}")
    end
    item = create(:item, categories: categories)

    assert_equal 3, item.categories.count
  end

  test "it has a photo by default" do
    item = create(:item, categories: [create(:category)])

    assert_equal 1, item.photos.count
  end
end

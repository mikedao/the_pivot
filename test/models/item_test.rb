require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  attr_reader :item

  test 'it is valid' do
    item = create(:item)
    assert item.valid?
  end

  test 'it cannot have an empty string as a title' do
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
    category = Category.create(name: "hot beverages")
    category.items.create(title: 'espresso', description: "this is black gold", price: 30000)
    category.items.create(title: 'espresso', description: "this is bleck gold", price: 30000)
    category.items.create(title: 'espresso', description: "this is back gold", price: 30000)

    assert_equal 1, Item.where(:title => "espresso").count
  end

  test "it has a valid price" do
    category = Category.create(name: "hot beverages")
    item1 = category.items.create(title: 'espresso', description: "this is black gold", price: 30000)
    item2 = category.items.create(title: 'italian roast', description: "this is blak gold", price: "10.00z")
    item3 = category.items.create(title: 'decaf something or other', description: "this is blakc gold", price: ".01")
    item4 = category.items.create(title: 'sludge', description: "this is blakc gold", price: 0.01)
    item5 = category.items.create(title: 'just straight espresso beans in a cup', description: "this is blakc gold")

    assert item1.valid?
    refute item2.valid?
    refute item3.valid?
    refute item4.valid?
    refute item5.valid?
  end

  test 'it can have many categories' do
    item = create(:item_with_categories, category_count: 2)

    assert_equal 2, item.categories.count
  end

  test "it has to have at least a category" do
    item = create(:item_with_categories, category_count: 1)
    item1 = create(:item_with_categories, category_count: 3)

    assert item.categories
    assert_equal 1, item.categories.count
    assert_equal 3, item1.categories.count
  end

  test "it has a photo by default" do
    category = Category.create(name: "hot beverages")
    item = category.items.create(title: 'espresso', description: "this is black gold", price: 30000)
    assert item.image.url
  end
end

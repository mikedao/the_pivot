require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  attr_reader :item

  test 'it is valid' do
    @item = Item.create(title: 'espresso', description: "this is black gold", price: 30000)
    assert item.valid?
  end

  test 'it cannot have an empty string as a name' do
    @item = Item.create(title: '', description: "this is black gold", price: 30000)
    assert item.invalid?
  end

  test "it cannot have an empty string as a description" do
    @item = Item.create(title: 'espresso', description: "", price: 30000)
    assert item.invalid?
  end

  test "it cannot have a duplicate title" do
    @item = Item.create(title: 'espresso', description: "this is black gold", price: 20000)
    @item1 = Item.create(title: 'espresso', description: "this is bleck gold", price: 30000)
    @item2 = Item.create(title: 'espresso', description: "this is back gold", price: 30000)
    assert_equal 1, Item.where(:title => "espresso").count
  end

  test "it has a valid price" do
    @item1 = Item.create(title: 'hot cocoa', description: "this is black gold", price: 1000)
    @item2 = Item.create(title: 'italian roast', description: "this is blak gold", price: "10.00z")
    @item3 = Item.create(title: 'decaf something or other', description: "this is blakc gold", price: ".01")
    @item4 = Item.create(title: 'sludge', description: "this is blakc gold", price: 0.01)
    @item5 = Item.create(title: 'just straight espresso beans in a cup', description: "this is blakc gold")

    assert @item1.valid?
    refute @item2.valid?
    refute @item3.valid?
    refute @item4.valid?
    refute @item5.valid?
  end


  test 'it can have many categories' do
    @item = Item.create(title: 'espresso', description: "this is black gold", price: 30000)
    @category1 = @item.categories.create(name: 'hot beverages')
    @category2 = @item.categories.create(name: 'cold beverages')
    assert_equal 2, item.categories.count
  end
end

require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  attr_reader :item

  def setup
    @item = Item.create(title: 'espresso')
    @category1 = @item.categories.create(name: 'hot beverages')
    @category2 = @item.categories.create(name: 'cold beverages')
  end

  test 'it is valid' do
    assert item.valid?
  end

  test 'it is invalid without a name' do
    item.title = nil
    assert item.invalid?
  end

  test 'it can have many categories' do
    assert_equal 2, item.categories.count
  end
end

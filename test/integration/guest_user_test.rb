require 'test_helper'

class GuestUserTest < ActionDispatch::IntegrationTest
  include Capybara::DSL

  attr_reader :item1, :item2, :category1, :category2

  def setup
    @item1 = Item.create(title: 'espresso', price: 9000)
    @category1 = item1.categories.create(name: 'Hot Beverages')
    @item2 = Item.create(title: 'cold pressed coffee', price: 8000)
    @category2 = item2.categories.create(name: 'cold beverages')
  end

  test 'a guest user can view home page' do
    visit root_path
    assert page.has_content?('Coffee House')
  end

  test 'a guest user can see all items' do
    visit root_path
    click_link_or_button('Menu')
    assert_equal items_path, current_path
    assert page.has_content?(item1.title)
    assert page.has_content?(category1.name)
  end

  test 'a guest user can browse items by category' do
    visit root_path
    click_link_or_button('Menu')
    click_link_or_button(category1.name)
    assert_equal items_path, current_path
    assert page.has_content?(item1.title)
    assert page.has_content?(category1.name)
    refute page.has_content?(item2.title)
    refute page.has_content?(category2.name)
  end
end

require 'test_helper'

class GuestUserTest < ActionDispatch::IntegrationTest
  include Capybara::DSL

  attr_reader :item1, :item2, :category1, :category2

  def setup
    @item1 = Item.create(name: 'espresso', cost: 9000)
    @category1 = item1.categories.create(name: 'hot beverages')
    @item2 = Item.create(name: 'cold pressed coffee', cost: 8000)
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
    assert page.has_content?(item1.name)
    assert page.has_content?(category1.name)
  end

  test 'a guest user can browse items by category' do
    # visit root_path
    # click_link_or_button('Menu')
    # select 'hot beverages', from: 'item[category]'
    # assert page.has_content?(item1.name)
    # assert page.has_content?(category1.name)
    # save_and_open_page
    # refute page.has_content?(item2.name)
    # refute page.has_content?(category2.name)
  end
end

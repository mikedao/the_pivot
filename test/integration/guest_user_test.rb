require 'test_helper'

class GuestUserTest < ActionDispatch::IntegrationTest
  include Capybara::DSL

  attr_reader :category, :item

  def setup
    @category = Category.create(name: 'hot beverages')
    @item = Item.create(name: 'espresso', cost: 9000)
  end

  test 'a guest user can view home page' do
    visit root_path
    assert page.has_content?('Coffee House')
  end

  test 'a guest user can see all items' do
    visit root_path
    click_link_or_button('Menu')
    assert_equal items_path, current_path
    assert page.has_content?(item.name)
    assert page.has_content?(category.name)
  end

  test 'a guest user can browse items by category' do
    # visit root_path
    # click_link_or_button('Menu')
  end
end

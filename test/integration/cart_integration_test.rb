require 'test_helper'

class CartIntegrationTest < ActionDispatch::IntegrationTest
  include Capybara::DSL

  test 'an unauthorized user can add an item to the cart' do
    item = Item.create(title: 'coffee', description: 'black nectar of the gods', price: 1200)
    visit "/items/#{item.id}"
    click_link_or_button('Add to Cart')
    within('#flash_notice') do
      assert page.has_content?('Added to Cart')
    end
    click_link_or_button('Cart')
    within('#cart_items') do
      assert page.has_content?('coffee')
      assert page.has_content?('1')
    end
  end
end

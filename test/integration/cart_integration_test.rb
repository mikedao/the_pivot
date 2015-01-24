require 'test_helper'

class CartIntegrationTest < ActionDispatch::IntegrationTest
  include Capybara::DSL

  test 'a cart starts empty' do
    visit '/'

    click_link_or_button('Cart')

    within('#cart_items') do
      assert page.has_content?('Your Cart Is Empty')
    end
  end

  test 'an unauthorized user can add an item to the cart' do
    item = Item.create(title: 'coffee', description: 'black nectar of the gods', price: 1200)
    visit "/items/#{item.id}"

    click_link_or_button('Add to Cart')

    within('#flash_notice') do
      assert page.has_content?('Added to Cart')
    end
  end

  test 'an unauthorized user with items in their cart can view their cart' do
    item = Item.create(title: 'coffee', description: 'black nectar of the gods', price: 1200)
    visit "/items/#{item.id}"

    click_link_or_button('Add to Cart')
    click_link_or_button('Cart')

    within('#cart_items') do
      assert page.has_content?('coffee')
      assert page.has_content?('1')
    end
  end

  test 'an unauthorized user can add up to 10 of the same item at one time' do
    item = Item.create(title: 'coffee', description: 'black nectar of the gods', price: 1200)

    visit "/items/#{item.id}"
    select "10", from: 'cart[quantity]'
    click_link_or_button('Add to Cart')
    click_link_or_button('Cart')

    within('#cart_items') do
      assert page.has_content?('coffee')
      assert page.has_content?('10')
    end
  end

  test 'an unauthorized user can add more of the same item' do
    item = Item.create(title: 'coffee', description: 'black nectar of the gods', price: 1200)

    visit "/items/#{item.id}"
    select "10", from: 'cart[quantity]'
    click_link_or_button('Add to Cart')
    visit "/items/#{item.id}"
    select "1", from: 'cart[quantity]'
    click_link_or_button('Add to Cart')
    click_link_or_button('Cart')

    within('#cart_items') do
      assert page.has_content?('coffee')
      assert page.has_content?('11')
    end
  end

  test 'an unauthorized user can add different items to the cart and show the correct price' do
    coffee = Item.create(title: 'coffee', description: 'black nectar of the gods', price: 1200)
    aeropress = Item.create(title: 'aeropress', description: 'light coffee', price: 1300)
    visit "/items/#{coffee.id}"

    select "1", from: 'cart[quantity]'
    click_link_or_button('Add to Cart')
    visit "/items/#{aeropress.id}"
    select "2", from: 'cart[quantity]'
    click_link_or_button('Add to Cart')
    click_link_or_button('Cart')

    within('#cart_items') do
      assert page.has_content?('coffee')
      assert page.has_content?('1')
      assert page.has_content?('$12.00')
      assert page.has_content?('aeropress')
      assert page.has_content?('2')
      assert page.has_content?('$26.00')
    end
  end

  test 'an unauthorized user cannot checkout until logged in' do
    
  end
end

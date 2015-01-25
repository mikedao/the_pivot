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
    item = Item.create(title: 'coffee', description: 'black nectar of the gods', price: 1200)
    visit "/items/#{item.id}"

    click_link_or_button('Add to Cart')
    click_link_or_button('Cart')
    click_link_or_button('Checkout')

    within('#flash_alert') do
      assert page.has_content?('You must login to checkout')
    end
    assert_equal showcart_path, current_path
  end

  test 'a user can edit the quantity of an item in their cart' do
    coffee = Item.create(title: 'coffee', description: 'black nectar of the gods', price: 1200)
    aeropress = Item.create(title: 'aeropress', description: 'light stuff', price: 1300)
    visit "/items/#{coffee.id}"
    click_link_or_button('Add to Cart')
    visit "/items/#{aeropress.id}"
    click_link_or_button('Add to Cart')
    click_link_or_button('Cart')

    within("#item_#{coffee.id}") do
      select '7', from: 'update_item_quantity[quantity]'
      click_link_or_button('Update Quantity')
    end

    within('#flash_notice') do
      assert page.has_content?('Item quantity updated')
    end
    assert page.has_content?('coffee')
    within("#quantity_#{coffee.id}") do
      assert page.has_content?('7')
    end
    assert page.has_content?('aeropress')
    assert_equal showcart_path, current_path
  end

  test 'a user can delete an item from their cart' do
    coffee = Item.create(title: 'coffee', description: 'black nectar of the gods', price: 1200)
    aeropress = Item.create(title: 'aeropress', description: 'light stuff', price: 1300)
    visit "/items/#{coffee.id}"
    click_link_or_button('Add to Cart')
    visit "/items/#{aeropress.id}"
    click_link_or_button('Add to Cart')
    click_link_or_button('Cart')

    within("#item_#{coffee.id}") do
      click_link_or_button('Delete')
    end

    within('#flash_notice') do
      assert page.has_content?('Item removed from cart')
    end
    refute page.has_content?('coffee')
    assert page.has_content?('aeropress')
    assert_equal showcart_path, current_path
  end

  test 'a user can empty their cart' do
    item = Item.create(title: 'coffee', description: 'black nectar of the gods', price: 1200)
    visit "/items/#{item.id}"
    click_link_or_button('Add to Cart')
    click_link_or_button('Cart')

    click_link_or_button('Empty Cart')

    assert page.has_content?('Your Cart Is Empty')
    assert_equal showcart_path, current_path
  end

  test 'item titles on cart page are links' do
    item = Item.create(title: 'coffee', description: 'black nectar of the gods', price: 1200)
    visit "/items/#{item.id}"
    click_link_or_button('Add to Cart')
    click_link_or_button('Cart')

    click_link_or_button('coffee')

    assert_equal item_path(item.id), current_path
  end

  test 'a user can checkout once logged in' do
    item = Item.create(
      title: 'coffee',
      description: 'black nectar of the gods',
      price: 1200
      )
    user = User.create(
      username: 'user123',
      password: 'password123',
      first_name: 'first',
      last_name: 'last',
      email: 'user123@example.com'
      )
    visit "/items/#{item.id}"
    select '2', from: 'cart[quantity]'
    click_link_or_button('Add to Cart')
    fill_in 'session[username]', with: user.username
    fill_in 'session[password]', with: user.password
    click_link_or_button('Login')
    click_link_or_button('Cart')

    click_link_or_button('Checkout')

    assert_equal user_order_path(user_id: user.id, id: user.orders.first.id), current_path
    # assert_template "users/#{user.id}/orders"
    assert page.has_content?("$24.00")
    assert page.has_content?("coffee")
  end
end

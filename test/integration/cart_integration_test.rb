require 'test_helper'

class CartIntegrationTest < ActionDispatch::IntegrationTest
  include Capybara::DSL

  test 'a cart starts empty' do
    visit '/'

    click_link_or_button('Cart')

    within('#cart_projects') do
      assert page.has_content?('Your Cart Is Empty')
    end
  end

  test 'an unauthorized user can add an project to the cart' do
    project = Project.create(title: 'coffee', description: 'black nectar of the gods', price: 1200)
    visit "/projects/#{project.id}"

    click_link_or_button('Add to Cart')

    within('#flash_notice') do
      assert page.has_content?('Added to Cart')
    end
  end

  test 'an unauthorized user with projects in their cart can view their cart' do
    project = Project.create(title: 'coffee', description: 'black nectar of the gods', price: 1200)
    visit "/projects/#{project.id}"

    click_link_or_button('Add to Cart')
    click_link_or_button('Cart')

    within('#cart_projects') do
      assert page.has_content?('coffee')
      assert page.has_content?('1')
    end

  end

  test 'an unauthorized user can add up to 10 of the same project at one time' do
    project = Project.create(title: 'coffee', description: 'black nectar of the gods', price: 1200)

    visit "/projects/#{project.id}"
    select "10", from: 'cart[quantity]'
    click_link_or_button('Add to Cart')
    click_link_or_button('Cart')

    within('#cart_projects') do
      assert page.has_content?('coffee')
      assert page.has_content?('10')
    end
  end

  test 'an unauthorized user can add more of the same project' do
    project = Project.create(title: 'coffee', description: 'black nectar of the gods', price: 1200)

    visit "/projects/#{project.id}"
    select "10", from: 'cart[quantity]'
    click_link_or_button('Add to Cart')
    visit "/projects/#{project.id}"
    select "1", from: 'cart[quantity]'
    click_link_or_button('Add to Cart')
    click_link_or_button('Cart')

    within('#cart_projects') do
      assert page.has_content?('coffee')
      assert page.has_content?('11')
    end
  end

  test 'an unauthorized user can add different projects to the cart and show the correct price' do
    coffee = Project.create(title: 'coffee', description: 'black nectar of the gods', price: 1200)
    aeropress = Project.create(title: 'aeropress', description: 'light coffee', price: 1300)
    visit "/projects/#{coffee.id}"

    select "1", from: 'cart[quantity]'
    click_link_or_button('Add to Cart')
    visit "/projects/#{aeropress.id}"
    select "2", from: 'cart[quantity]'
    click_link_or_button('Add to Cart')
    click_link_or_button('Cart')

    within('#cart_projects') do
      assert page.has_content?('coffee')
      assert page.has_content?('1')
      assert page.has_content?('$12.00')
      assert page.has_content?('aeropress')
      assert page.has_content?('2')
      assert page.has_content?('$26.00')
    end
  end

  test 'an unauthorized user cannot checkout until logged in' do
    project = Project.create(title: 'coffee', description: 'black nectar of the gods', price: 1200)
    visit "/projects/#{project.id}"

    click_link_or_button('Add to Cart')
    click_link_or_button('Cart')
    click_link_or_button('Checkout')

    within('#flash_alert') do
      assert page.has_content?('You must login to checkout')
    end
    assert_equal showcart_path, current_path
  end

  test 'a user can edit the quantity of an project in their cart' do
    coffee = Project.create(title: 'coffee', description: 'black nectar of the gods', price: 1200)
    aeropress = Project.create(title: 'aeropress', description: 'light stuff', price: 1300)
    visit "/projects/#{coffee.id}"
    click_link_or_button('Add to Cart')
    visit "/projects/#{aeropress.id}"
    click_link_or_button('Add to Cart')
    click_link_or_button('Cart')

    within("#project_#{coffee.id}") do
      select '7', from: 'update_project_quantity[quantity]'
      click_link_or_button('Update Quantity')
    end

    within('#flash_notice') do
      assert page.has_content?('Project quantity updated')
    end
    assert page.has_content?('coffee')
    within("#quantity_#{coffee.id}") do
      assert page.has_content?('7')
    end
    assert page.has_content?('aeropress')
    assert_equal showcart_path, current_path
  end

  test 'a user can delete an project from their cart' do
    coffee = Project.create(title: 'coffee', description: 'black nectar of the gods', price: 1200)
    aeropress = Project.create(title: 'aeropress', description: 'light stuff', price: 1300)
    visit "/projects/#{coffee.id}"
    click_link_or_button('Add to Cart')
    visit "/projects/#{aeropress.id}"
    click_link_or_button('Add to Cart')
    click_link_or_button('Cart')

    within("#project_#{coffee.id}") do
      click_link_or_button('Delete')
    end

    within('#flash_notice') do
      assert page.has_content?('Project removed from cart')
    end
    refute page.has_content?('coffee')
    assert page.has_content?('aeropress')
    assert_equal showcart_path, current_path
  end

  test 'a user can empty their cart' do
    project = Project.create(title: 'coffee', description: 'black nectar of the gods', price: 1200)
    visit "/projects/#{project.id}"
    click_link_or_button('Add to Cart')
    click_link_or_button('Cart')

    click_link_or_button('Empty Cart')

    assert page.has_content?('Your Cart Is Empty')
    assert_equal showcart_path, current_path
  end

  test 'project titles on cart page are links' do
    project = Project.create(title: 'coffee', description: 'black nectar of the gods', price: 1200)
    visit "/projects/#{project.id}"
    click_link_or_button('Add to Cart')
    click_link_or_button('Cart')

    click_link_or_button('coffee')

    assert_equal project_path(project.id), current_path
  end

  test 'a user can checkout once logged in' do
    project = Project.create(
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
    visit "/projects/#{project.id}"
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

require 'test_helper'

class AdminUserTest < ActionDispatch::IntegrationTest
  include Capybara::DSL

  attr_reader :user, :item1, :item2, :category1, :category2

  def setup
    @user = User.create(username: 'user',
                password: 'password',
                first_name: 'John',
                last_name: 'Doe',
                email: 'example@example.com',
                role: 1)
    @category1 = Category.create(name: 'Hot Beverages')
    @category2 = Category.create(name: 'cold beverages')
    @item1 = category1.items.create(title: 'espresso', description: "this is black gold", price: 30000)
    @item2 = category2.items.create(title: 'cold pressed coffee', price: 8000, description: "hipster nonsense", price: 20000)
  end

  test 'an admin user can view home page' do
    visit root_path
    assert page.has_content?('Cinema Coffee')
  end

  test 'an admin user can see all items' do
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    visit root_path
    click_link_or_button('Menu')
    assert_equal items_path, current_path
    assert page.has_content?(item1.title)
    assert page.has_content?(category1.name)
  end

  test "an admin user has a unique email" do
    @user1 = User.create(username: 'userd',
                        password: 'password',
                        first_name: 'Johnn',
                        last_name: 'Does',
                        email: 'example@example.com',
                        role: 1)
    assert_equal 1, User.all.count
  end

  test "registered admin can see create category on menu page" do
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    visit root_path
    click_link_or_button('Admin Dashboard')
    assert admin_dashboard_path, current_path
    within ('#admin_header') do
      assert page.has_content?("Admin Dashboard")
    end
  end

  test "registered admin can go to the admin categories page" do
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    visit root_path
    click_link_or_button('Admin Dashboard')
    assert admin_dashboard_path, current_path

    click_link_or_button('Category')
    assert admin_categories_path, current_path
    within ('#categories_header') do
      assert page.has_content?("Categories")
    end
  end

  test "registered admin can create a category" do
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    visit admin_categories_path
    fill_in "categories[name]", with: "Brew"
    click_button 'Add Category'
      assert page.has_content?("Brew")
  end

  test "registed admin can create a new item" do
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    visit admin_dashboard_path
    click_link_or_button('Items')
    fill_in "item[title]", with: "Danish"
    fill_in "item[price]", with: 4
    fill_in "item[description]",  with: "Flakey raspberry filled pastry."
    file_path = Rails.root + 'app/assets/images/foods.jpg'
    attach_file('item[image]', file_path)
    select "cold beverages", from: "item[categories][]"
    click_button 'Create Item'
    assert page.has_content?("Danish")
  end

  test "registed admin can create a new item without an image" do
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    visit admin_dashboard_path
    click_link_or_button('Items')
    fill_in "item[title]", with: "something"
    fill_in "item[price]", with: 4
    fill_in "item[description]",  with: "Flakey raspberry filled pastry."
    select "cold beverages", from: "item[categories][]"
    click_button 'Create Item'
    assert page.has_content?("something")
  end

  test "registered admin can go to admin items page" do
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    visit admin_dashboard_path
    click_link_or_button('Items')
    assert admin_items_path, current_path
      within ('#items_header') do
        assert page.has_content?('Items')
    end
  end

  test "registered admin can go to the admin orders page" do
    ApplicationController.any_instance.stubs(:current_user).returns(user)
      visit admin_dashboard_path
      click_link_or_button('Orders')
      assert admin_orders_path, current_path
        within('#orders_header') do
          assert page.has_content?('Orders')
    end
  end

  test 'registered admin can delete items' do
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    visit admin_items_path
      assert 2, Item.all.count
      first('.item_delete').click_link_or_button('Delete')
      assert 1, Item.all.count
  end


  test "registered admin can see edit an item in the admin item page" do
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    visit admin_items_path
    first('.item_edit').click_link_or_button('Edit')
    within("#edit") do
      assert page.has_content?("Edit Item")
    end
    fill_in "item[title]", with: "Italian Drip"
    click_button "Update"
    assert page.has_content?("Italian Drip")
  end

  test "an admin can view all the orders" do
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    @non_admin = User.create(username: 'yayaya',
                             password: 'password',
                             first_name: 'John',
                             last_name: 'Doe',
                             email: 'unique@yahoo.com',
                             role: 0)
    @order = Order.create(total_cost: 100, user_id: @non_admin.id, status: "completed")
    @item = @order.items.create(title: 'coffee', description: 'black nectar of the gods', price: 1200)

    visit root_url

    click_link_or_button('Admin Dashboard')
    click_link_or_button('Orders')

    within('#completed') do
      assert page.has_content?("Order #{@order.id}")
    end
  end

  test "an admin can change order status" do
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    @non_admin = User.create(username: 'yayaya',
                             password: 'password',
                             first_name: 'John',
                             last_name: 'Doe',
                             email: 'unique@yahoo.com',
                             role: 0)
    @order = Order.create(total_cost: 100, user_id: @non_admin.id, status: "ordered")
    @item = @order.items.create(title: 'coffee', description: 'black nectar of the gods', price: 1200)

    visit root_url
    click_link_or_button('Admin Dashboard')
    click_link_or_button('Orders')

    within("#ordered") do
      select 'completed', from: "update_order_status[status_#{@order.id}]"
      click_link_or_button('Update Status')
    end

    within("#completed") do
      assert page.has_content?("Order #{@order.id}")
    end
  end

  test "an admin can retire an item" do
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    Item.destroy_all
    @item = Item.create(title: 'coffee', description: 'black nectar of the gods', price: 1200, retired: false)

    visit admin_items_path
    select 'true', from: "retire[status_#{@item.id}]"
    click_link_or_button('Retire')

    assert page.has_content?("Retired")
  end

  test "an item does not appear on menu after admin retires it" do
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    Item.destroy_all
    @item = Item.create(title: 'coffee', description: 'black nectar of the gods', price: 1200, retired: false)
    visit items_path

    assert page.has_content?('black nectar')

    visit admin_items_path
    select 'true', from: "retire[status_#{@item.id}]"
    click_link_or_button('Retire')

    visit items_path
    refute page.has_content?('black nectar')
  end

  test "an admin updates an order status through admin dashboard and the order has a changed status" do
    admin = create(:user, role: 1)
    ApplicationController.any_instance.stubs(:current_user).returns(admin)
    order = create(:order, status: "paid")
    orig_status = order.status

    visit admin_dashboard_path
    click_link_or_button "Orders"
    select "completed", from: "update_order_status[status_#{order.id}]"
    click_button "Update Status"

    refute_equal orig_status, order.reload.status
  end
end

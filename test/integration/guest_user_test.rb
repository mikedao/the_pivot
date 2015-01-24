require 'test_helper'

class GuestUserTest < ActionDispatch::IntegrationTest
  include Capybara::DSL

  attr_reader :user_admin, :user_user, :item1, :item2, :category1, :category2

  def setup
    @user_admin = User.create(username: 'user',
                        password: 'password',
                        first_name: 'John',
                        last_name: 'Doe',
                        email: 'example@example.com',
                        role: 1)

    @user_user = User.create(username: "jeff",
                            password: 'wan',
                            first_name: 'Jeff',
                            last_name: 'Wan',
                            email: 'jwan622@example.com',
                            role: 0)

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
    ApplicationController.any_instance.stubs(:current_user).returns(user_user)
    visit root_path
    click_link_or_button('Menu')
    assert_equal items_path, current_path
    assert page.has_content?(item1.title)
    assert page.has_content?(category1.name)
  end

  test 'a guest user can browse items by category' do
    # skip
    ApplicationController.any_instance.stubs(:current_user).returns(user_user)
    visit root_path
    click_link_or_button('Menu')
    click_link_or_button(category1.name)
    assert_equal items_path, current_path
    assert page.has_content?(item1.title)
    assert page.has_content?(category1.name)
    refute page.has_content?(item2.title)
  end

  test "registered admin can create category" do
    skip
    ApplicationController.any_instance.stubs(:current_user).returns(user_admin)
    visit items_path
    click_link_or_button "Create Category"
    fill_in "categories[name]", with: "Merchandise"
    click_link_or_button "Add Category"
    assert page.has_content?("Merchandise")
  end

  test "unregistered admin cannot see category" do
    ApplicationController.any_instance.stubs(:current_user).returns(user_user)
    visit items_path
    refute page.has_content?("Create Category")
  end
end

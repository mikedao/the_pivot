require 'test_helper'

class AdminUserTest < ActionDispatch::IntegrationTest
  include Capybara::DSL
  include FactoryGirl::Syntax::Methods

  attr_reader :user, :item1, :item2, :category1, :category2

  def setup
    @user = User.create(username: 'user',
                password: 'password',
                first_name: 'John',
                last_name: 'Doe',
                email: 'example@example.com',
                role: 1)

    @item1 = Item.create(title: 'espresso', description: "this is black gold", price: 30000)
    @category1 = item1.categories.create(name: 'Hot Beverages')
    @item2 = Item.create(title: 'cold pressed coffee', price: 8000, description: "hipster nonsense", price: 20000)
    @category2 = item2.categories.create(name: 'cold beverages')
  end

  test 'an admin user can view home page' do
    visit root_path
    assert page.has_content?('Coffee House')
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
    skip
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    visit root_path
    click_link_or_button('Admin Dashboard')
    assert admins_path, current_path
    within ('#admin_header') do
      assert page.has_content?("Welcome Admin")
    end
  end


  test "registered admin can see edit button on menu page" do
    skip
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    visit items_path
    first(:link, "Edit").click
    within("#edit") do
      assert page.has_content?("Edit Item")
    end
    fill_in "items[title]", with: "Italian Drip"
    fill_in "items[price]", with: 10000
    click_button "Submit"
    assert page.has_content?("Italian Drip")
    assert page.has_content?(10000)
  end
end

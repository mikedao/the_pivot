require 'test_helper'

class GuestUserTest < ActionDispatch::IntegrationTest
  include Capybara::DSL
  include FactoryGirl::Syntax::Methods

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

    @category1 = Category.create(name: 'Hot Beverages')
    @category2 = Category.create(name: 'cold beverages')
    @item1 = category1.items.create(title: 'espresso', description: "this is black gold", price: 30000)
    @item2 = category2.items.create(title: 'cold pressed coffee', price: 8000, description: "hipster nonsense")
  end

  test 'a guest user can view home page' do
    visit root_path
    assert page.has_content?('Cinema Coffee')
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
    ApplicationController.any_instance.stubs(:current_user).returns(user_admin)
    visit admin_dashboard_path
    click_link_or_button "Category"
    fill_in "categories[name]", with: "Blah"
    click_link_or_button "Add Category"
    assert page.has_content?("Blah")
  end

  test "unregistered admin cannot see category" do
    ApplicationController.any_instance.stubs(:current_user).returns(user_user)
    visit items_path
    refute page.has_content?("Create Category")
  end

  test "an unauthorised user can view a single item's page" do
    item = Item.create(title: 'coffee', description: 'black nectar of the gods', price: 1200)

    visit root_url
    click_link_or_button('Menu')
    click_link_or_button('coffee')

    within('#title') do
      assert page.has_content?('coffee')
    end

    within('#description') do
      assert page.has_content?('black nectar of the gods')
    end

    within('#price') do
      assert page.has_content?('$12.00')
    end
  end

  test "an unauthorized user can signup" do
    visit root_url
    click_link_or_button('Signup')

    fill_in 'signup[username]', with: 'theChosen1'
    fill_in 'signup[password]', with: 'gryffendor'
    fill_in 'signup[password_confirmation]', with: 'gryffendor'
    fill_in 'signup[first_name]', with: 'Harry'
    fill_in 'signup[last_name]', with: 'Potter'
    fill_in 'signup[email]', with: 'RedHeadLover@hogwarts.com'

    click_link_or_button('Create Account')

    assert current_path, root_url
    assert page.has_content?('Welcome, Harry')
  end

  test "if user already exists they can't sign up again" do
    visit root_url
    click_link_or_button('Signup')

    fill_in 'signup[username]', with: "jeff"
    fill_in 'signup[password]', with: 'wan'
    fill_in 'signup[password_confirmation]', with: 'wan'
    fill_in 'signup[first_name]', with: 'Jeff'
    fill_in 'signup[last_name]', with: 'Wan'
    fill_in 'signup[email]', with: 'jwan622@example.com'

    click_link_or_button('Create Account')
    within('#flash_notice') do
      assert page.has_content?('Account Already Exists')
    end
  end

  test "a unauthorized user cannot see another user's order page" do
    order = create(:order)
    user = order.user

    visit "/users/#{user.id}/orders/"

    refute page.has_content?("Order History")
    assert page.has_content?("Nice Try")

    visit "/users/#{user.id}/orders/#{order.id}"

    refute page.has_content?("Order #{order.id}")
    assert page.has_content?("Nice Try")
  end
end

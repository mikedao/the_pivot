require "test_helper"

class AdminUserTest < ActionDispatch::IntegrationTest
  include Capybara::DSL

  test "an admin can log in and get to the dashboard" do
    create(:admin)

    visit root_path
    fill_in "session[username]", with: "admin"
    fill_in "session[password]", with: "password"
    click_link_or_button("Login")

    assert page.has_content?("Platform Admin")
  end

  test "an admin when logging in, is brought to the platform dashboard" do
    create(:admin)

    visit root_path
    fill_in "session[username]", with: "admin"
    fill_in "session[password]", with: "password"
    click_link_or_button("Login")

    assert_equal admin_dashboard_path, current_path
  end

  test "an admin when logged in has an Admin Dashboard link" do
    admin = create(:admin)
    ApplicationController.any_instance.stubs(:current_user).returns(admin)

    visit root_path

    assert page.has_content?("Admin Dashboard")
  end

  test "an admin user can see all projects" do
    skip
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    visit root_path
    click_link_or_button("Menu")
    assert_equal projects_path, current_path
    assert page.has_content?(project1.title)
    assert page.has_content?(category1.name)
  end

  test "an admin can create a category" do
    admin = create(:admin)
    ApplicationController.any_instance.stubs(:current_user).returns(admin)
    visit root_path
    click_link_or_button("Admin Dashboard")
    click_link_or_button("Categories")
    fill_in "categories[name]", with: "Blah"
    click_link_or_button("Add Category")

    assert page.has_content?("Blah")
  end

  test "a category with the same name cannot be created" do
    admin = create(:admin)
    ApplicationController.any_instance.stubs(:current_user).returns(admin)
    visit root_path
    click_link_or_button("Admin Dashboard")
    click_link_or_button("Categories")
    fill_in "categories[name]", with: "Blah"
    click_link_or_button("Add Category")
    fill_in "categories[name]", with: "Blah"
    click_link_or_button("Add Category")

    assert page.has_content?("Please Try Again")
  end

  test "registered admin can go to the admin categories page" do
    admin = create(:admin)
    ApplicationController.any_instance.stubs(:current_user).returns(admin)
    visit root_path
    click_link_or_button("Admin Dashboard")
    click_link_or_button("Categories")

    assert_equal admin_categories_path, current_path
  end

  test "registed admin can create a new project" do
    skip
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    visit admin_dashboard_path
    click_link_or_button("Projects")
    fill_in "project[title]", with: "Danish"
    fill_in "project[price]", with: 4
    fill_in "project[description]",  with: "Flakey raspberry filled pastry."
    file_path = Rails.root + "app/assets/images/foods.jpg"
    attach_file("project[image]", file_path)
    select "cold beverages", from: "project[categories][]"
    click_button "Create Project"
    assert page.has_content?("Danish")
  end

  test "registed admin can create a new project without an image" do
    skip
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    visit admin_dashboard_path
    click_link_or_button("Projects")
    fill_in "project[title]", with: "something"
    fill_in "project[price]", with: 4
    fill_in "project[description]",  with: "Flakey raspberry filled pastry."
    select "cold beverages", from: "project[categories][]"
    click_button "Create Project"
    assert page.has_content?("something")
  end

  test "registered admin can go to admin projects page" do
    skip
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    visit admin_dashboard_path
    click_link_or_button("Projects")
    assert admin_projects_path, current_path
    within ("#projects_header") do
      assert page.has_content?("Projects")
    end
  end

  test "registered admin can go to the admin orders page" do
    skip
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    visit admin_dashboard_path
    click_link_or_button("Orders")
    assert admin_orders_path, current_path
    within("#orders_header") do
      assert page.has_content?("Orders")
    end
  end

  test "registered admin can delete projects" do
    skip
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    visit admin_projects_path
    assert 2, Project.all.count
    first(".project_delete").click_link_or_button("Delete")
    assert 1, Project.all.count
  end


  test "registered admin can see edit an project in the admin project page" do
    skip
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    visit admin_projects_path
    first(".project_edit").click_link_or_button("Edit")
    within("#edit") do
      assert page.has_content?("Edit Project")
    end
    fill_in "project[title]", with: "Italian Drip"
    click_button "Update"
    assert page.has_content?("Italian Drip")
  end

  test "an admin can view all the orders" do
    skip
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    @non_admin = User.create(username: "yayaya",
                             password: "password",
                             first_name: "John",
                             last_name: "Doe",
                             email: "unique@yahoo.com"
                             )
    @order = Order.create(total_cost: 100,
                          user_id: @non_admin.id,
                          status: "completed")
    @project = @order.projects.create(title: "coffee",
                                      description: "black nectar of the gods",
                                      price: 1200)

    visit root_url

    click_link_or_button("Admin Dashboard")
    click_link_or_button("Orders")

    within("#completed") do
      assert page.has_content?("Order #{@order.id}")
    end
  end

  test "an admin can change order status" do
    skip
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    @non_admin = User.create(username: "yayaya",
                             password: "password",
                             first_name: "John",
                             last_name: "Doe",
                             email: "unique@yahoo.com"
                             )
    @order = Order.create(total_cost: 100,
                          user_id: @non_admin.id,
                          status: "ordered")
    @project = @order.projects.create(title: "coffee",
                                      description: "black nectar of the gods",
                                      price: 1200)

    visit root_url
    click_link_or_button("Admin Dashboard")
    click_link_or_button("Orders")

    within("#ordered") do
      select "completed", from: "update_order_status[status_#{@order.id}]"
      click_link_or_button("Update Status")
    end

    within("#completed") do
      assert page.has_content?("Order #{@order.id}")
    end
  end

  test "an admin can retire an project" do
    skip
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    Project.destroy_all
    @project = Project.create(title: "coffee",
    description: "black nectar of the gods", price: 1200, retired: false)

    visit admin_projects_path
    select "true", from: "retire[status_#{@project.id}]"
    click_link_or_button("Retire")

    assert page.has_content?("Retired")
  end

  test "an project does not appear on menu after admin retires it" do
    skip
    ApplicationController.any_instance.stubs(:current_user).returns(user)
    Project.destroy_all
    @project = Project.create(title: "coffee",
                              description: "black nectar of the gods",
                              price: 1200,
                              retired: false)
    visit projects_path

    assert page.has_content?("black nectar")

    visit admin_projects_path
    select "true", from: "retire[status_#{@project.id}]"
    click_link_or_button("Retire")

    visit projects_path
    refute page.has_content?("black nectar")
  end

  test "an admin updates an order status through admin dashboard and
        the order has a changed status" do
    skip
    admin = create(:user)
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

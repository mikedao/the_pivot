require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  attr_reader :project

  test "it is valid" do
    project = build(:project)
    project.categories << create(:category)
    assert project.valid?
  end

  test "it cannot have an empty string as a title" do
    category = Category.create(name: "hot beverages")
    project = category.projects.create(title: '', description: "this is black gold", price: 30000)
    assert project.invalid?
  end

  test "it cannot have an empty string as a description" do
    category = Category.create(name: "hot beverages")

    project = category.projects.create(title: 'espresso', description: "", price: 30000)
    assert project.invalid?
  end

  test "it cannot have a duplicate title" do
    category = create(:category)
    create(:project, title: "espresso", categories: [category])
    invalid_project = build(:project, title: "espresso", categories: [category])

    assert invalid_project.invalid?
  end

  test "it has a valid price" do
    category = create(:category, name: "hot beverages")
    project1 = create(:project, categories: [category], price: 40004)
    invalid_project1 = build(:project, categories: [category], price: 400.04)
    invalid_project2 = build(:project, categories: [category], price: "dasj")
    invalid_project3 = build(:project, categories: [category], price: "4%")
    invalid_project4 = build(:project, categories: [category], price: -4)
    invalid_project5 = build(:project, categories: [category], price: 4000000)

    assert project1.valid?
    refute invalid_project1.valid?
    refute invalid_project2.valid?
    refute invalid_project3.valid?
    refute invalid_project4.valid?
    refute invalid_project5.valid?
  end

  test "it must have at least one category" do
    project = build(:project, categories: [])
    assert project.invalid?
  end

  test "it can have multiple categories" do
    categories = []
    1.upto(3) do |i|
      categories << create(:category, name: "Bad Category#{i}")
    end
    project = create(:project)
    project.categories = categories

    assert_equal 3, project.categories.count
  end

  test "it has a photo by default" do
    project = create(:project, categories: [create(:category)])

    assert_equal 1, project.photos.count
  end
end

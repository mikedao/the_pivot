require "test_helper"

class ProjectTest < ActiveSupport::TestCase
  test "it is valid" do
    project = build(:project)
    project.categories << create(:category)

    assert project.valid?
  end

  test "it cannot have an empty string as a title" do
    category = create(:category)
    project = category.projects.create(title: "",
                                       description: "this is black gold",
                                       price: 30000)
    assert project.invalid?
  end

  test "it cannot have an empty string as a description" do
    category = create(:category)
    project = category.projects.create(title: "espresso",
                                       description: "",
                                       price: 30000)
    assert project.invalid?
  end

  test "it must have a description of reasonable length" do
    project1 = create(:project)
    project1.description = "bob"
    project2 = create(:project)
    project2.description = "b" * 4000
    project3 = create(:project)
    project3.description = "b" * 99

    assert project1.invalid?
    assert project2.invalid?
    assert project3.invalid?
  end

  test "it cannot have a duplicate title" do
    category = create(:category)
    create(:project, title: "espresso")
    invalid_project = build(:project, title: "espresso", categories: [category])

    assert invalid_project.invalid?
  end

  test "it has a valid price" do
    category = create(:category)
    project1 = create(:project, categories: [category], price: 40004)
    invalid_projects = [build(:project, categories: [category], price: 400.04),
                        build(:project, categories: [category], price: "dasj"),
                        build(:project, categories: [category], price: "4%"),
                        build(:project, categories: [category], price: -4),
                        build(:project, categories: [category], price: 4000000),
                        build(:project, categories: [category], price: 999)]

    assert project1.valid?
    invalid_projects.each do |project|
      refute project.valid?
    end
  end

  test "it must have at least one category" do
    project = build(:project, categories: [])
    assert project.invalid?
  end

  test "it can have multiple categories" do
    categories = []
    3.times do
      categories << create(:category)
    end
    project = create(:project)
    project.categories = categories

    assert_equal 3, project.categories.count
  end

  test "it has a photo by default" do
    project = create(:project)

    assert_equal 1, project.photos.count
  end
end

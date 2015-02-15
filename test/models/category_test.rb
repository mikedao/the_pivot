require 'test_helper'

class CategoryTest < ActiveSupport::TestCase

  test "it has attributes" do
    category = build(:category)
    assert category.valid?
  end

  test "category is not valid without a name" do
    category = build(:category, name: nil)
    category = build(:category, name: "  ")

    assert category.invalid?
  end

  test "category names are unique" do
    create(:category, name: "water")
    dup_category = build(:category, name: "water")

    assert dup_category.invalid?
  end
end

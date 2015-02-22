require "test_helper"

class PhotoTest < ActiveSupport::TestCase
  test "photo has attributes" do
    photo = build(:photo)

    assert photo.valid?
  end

  test "photo is not valid without image_file_name" do
    photo = build(:photo, image_file_name: nil)

    assert photo.invalid?
  end

  test "photo is not valid without image_content_type" do
    photo = build(:photo, image_content_type: nil)

    assert photo.invalid?
  end

  test "photo is not valid without file size" do
    photo = build(:photo, image_file_size: nil)

    assert photo.invalid?
  end

  test "photo is not valid with empty strings as file name" do
    photo = build(:photo, image_file_name: "  ")

    assert photo.invalid?
  end

  test "photo is not valid with non-standard content types" do
    photo = build(:photo, image_content_type: ".bob")

    assert photo.invalid?
  end
end

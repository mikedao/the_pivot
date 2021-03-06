class Photo < ActiveRecord::Base
  belongs_to :project
  belongs_to :category

  validates :image_file_name, presence: true
  validates :image_content_type, presence: true
  validates :image_file_size, presence: true

  has_attached_file :image,
                    styles: { medium: "560x390", thumb: "230x230" },
                    default_url: "/images/:styles/test_photo.jpg"

  validates_attachment_content_type :image,
                    content_type: ["image/jpg", "image/jpeg", "image/png"]
end

class Photo < ActiveRecord::Base
  belongs_to :project

  validates :image_file_name, presence: true
  validates :image_content_type, presence: true
  validates :image_file_size, presence: true

  has_attached_file :image,
                    styles: { medium: "300x300", thumb: "100x100" },
                    default_url: "/images/:styles/beans.png"

  validates_attachment_content_type :image,
                                    content_type: ['image/jpg', 'image/jpeg', 'image/png']
end

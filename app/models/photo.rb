class Photo < ActiveRecord::Base
  belongs_to :project

  validates :image_file_name, presence: true, uniqueness: true
  validates :image_content_type, presence: true
  validates :image_file_size, presence: true
end

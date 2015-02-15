class Photo < ActiveRecord::Base

  # has_attached_file :img,
  # styles: { item_manage_list: "75x75>",
  #   # menu_list: "150x150>",
  #   # item_list: "400x400>" }
  #   # validates_attachment_content_type :img, content_type: /\Aimage\/.*\Z/
  #
  validates :image_file_name, presence: true, uniqueness: true
  validates :image_content_type, presence: true
  validates :image_file_size, presence: true
end

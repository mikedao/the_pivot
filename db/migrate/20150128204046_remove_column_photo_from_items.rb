class RemoveColumnPhotoFromItems < ActiveRecord::Migration
  def change
    remove_column :items, :photo
  end
end

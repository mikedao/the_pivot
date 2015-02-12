class UpdatePhotos < ActiveRecord::Migration
  def change
    remove_column :photos, :item_id

    add_reference :photos, :item, index: true
  end
end

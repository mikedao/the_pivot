class AddColumnToPhoto < ActiveRecord::Migration
  def change
    add_column :photos, :category_id, :integer
  end
end

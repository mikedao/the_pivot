class RenameColumnsItemToProject < ActiveRecord::Migration
  def change
    rename_column :photos, :item_id, :project_id
    rename_column :projects_categories, :item_id, :project_id
    rename_column :loans, :item_id, :project_id
  end
end

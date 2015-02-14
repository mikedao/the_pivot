class RenameItemsCategoriesToProjectsCategories < ActiveRecord::Migration
  def change
    rename_table :items_categories, :projects_categories
  end
end

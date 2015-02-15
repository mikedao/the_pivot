class RenameItemsProjects < ActiveRecord::Migration
  def change
    rename_table :items, :projects
  end
end

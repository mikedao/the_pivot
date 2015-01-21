class UpdateColumnsInItems < ActiveRecord::Migration
  def change
    rename_column :items, :name, :title
    rename_column :items, :cost, :price
    add_column :items, :description, :string
    add_column :items, :photo, :string
  end
end

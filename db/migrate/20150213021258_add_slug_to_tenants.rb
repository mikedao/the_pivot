class AddSlugToTenants < ActiveRecord::Migration
  def change
    add_column :tenants, :slug, :string
  end
end

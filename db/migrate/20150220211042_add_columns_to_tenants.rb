class AddColumnsToTenants < ActiveRecord::Migration
  def change
    add_column :tenants, :active, :boolean, default: false
    add_column :tenants, :approved, :boolean, default: false
  end
end

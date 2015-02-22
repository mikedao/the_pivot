class AddColumnToTenants < ActiveRecord::Migration
  def change
    add_column :tenants, :active, :boolean
    add_column :tenants, :approved, :boolean
  end
end

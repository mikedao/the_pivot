class RemoveApprovedFromTenants < ActiveRecord::Migration
  def change
    remove_column :tenants, :approved
    remove_column :tenants, :active
  end
end

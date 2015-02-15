class RemoveIndexFromUsersTenantId < ActiveRecord::Migration
  def change
    remove_column :users, :tenant_id

    add_column :users, :tenant_id, :integer
  end
end

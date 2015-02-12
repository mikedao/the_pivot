class CreateTenants < ActiveRecord::Migration
  def change
    create_table :tenants do |t|
      t.string :location
      t.string :organization

      t.timestamps null: false
    end
  end
end

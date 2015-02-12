class UpdateItems < ActiveRecord::Migration
  def change
    remove_column :items, :image_file_name
    remove_column :items, :image_content_type
    remove_column :items, :image_file_size
    remove_column :items, :image_updated_at

    add_reference :items, :tenant, index: true

    add_column :items, :requested_by, :date
    add_column :items, :reqpayment_begin, :date
    add_column :items, :repayment_rate, :integer

  end
end

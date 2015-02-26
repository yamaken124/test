class AddSingleOrderDetailIdToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :single_order_detail_id, :integer, index: :true, after: :address_id
    add_foreign_key :payments, :single_order_details
  end
end

class ChangeColumnPaymentIdToItemIdOfShipment < ActiveRecord::Migration
  def change
    remove_foreign_key :shipments, :payments
    remove_column :shipments, :payment_id, :integer
    add_column :shipments, :single_line_item_id, :integer, after: :address_id
    add_foreign_key :shipments, :single_line_items
  end
end

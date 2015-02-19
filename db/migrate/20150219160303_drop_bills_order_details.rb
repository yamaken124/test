class DropBillsOrderDetails < ActiveRecord::Migration
  def change
    drop_table :bills_order_details
  end

  def down
    create_table :bills_order_details do |t|
      t.references :bill, index: true
      t.integer :order_detail_id
      t.string :order_detail_type

      t.timestamps null: false
    end
    add_foreign_key :bills_order_details, :bills
  end
end

class DropBillTables < ActiveRecord::Migration
  def up
    drop_table :bills_payments
    drop_table :bills
  end

  def down
    create_table :bills do |t|
      t.references :address, index: true
      t.integer :item_total
      t.integer :total
      t.integer :shipment_total
      t.integer :additional_tax_total
      t.integer :used_point

      t.timestamps null: false
    end
    add_foreign_key :bills, :addresses

    create_table :bills_payments do |t|
      t.references :bill, index: true
      t.references :payment, index: true

      t.timestamps null: false
    end
    add_foreign_key :bills_payments, :bills
    add_foreign_key :bills_payments, :payments
  end
end

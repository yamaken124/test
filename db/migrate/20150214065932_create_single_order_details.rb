class CreateSingleOrderDetails < ActiveRecord::Migration
  def change
    create_table :single_order_details do |t|
      t.references :single_order, index: true
      t.string :number
      t.integer :item_total
      t.integer :total
      t.datetime :completed_at
      t.references :address, index: true
      t.integer :shipment_total
      t.integer :additional_tax_total
      t.integer :adjustment_total
      t.integer :item_count
      t.date :date
      t.integer :lock_version

      t.timestamps null: false
    end
    add_foreign_key :single_order_details, :single_orders
    add_foreign_key :single_order_details, :addresses
  end
end

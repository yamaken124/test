class CreateSingleOrderDetails < ActiveRecord::Migration
  def change
    create_table :single_order_details do |t|
      t.references :single_order, index: true
      t.string :number
      t.integer :item_total, default: 0, null: false
      t.integer :total, default: 0, null: false
      t.datetime :completed_at
      t.references :address, index: true
      t.integer :shipment_total, default: 0, null: false
      t.integer :additional_tax_total, default: 0, null: false
      t.integer :adjustment_total, default: 0, null: false
      t.integer :item_count, default: 0, null: false
      t.date :date
      t.integer :lock_version, default: 0, null: false

      t.timestamps null: false
    end
    add_foreign_key :single_order_details, :single_orders
    add_foreign_key :single_order_details, :addresses
  end
end

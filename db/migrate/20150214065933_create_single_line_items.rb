class CreateSingleLineItems < ActiveRecord::Migration
  def change
    create_table :single_line_items do |t|
      t.references :variant, index: true
      t.references :single_order_detail, index: true
      t.integer :quantity
      t.integer :price
      t.integer :tax_rate_id
      t.integer :additional_tax_total

      t.timestamps null: false
    end
    add_foreign_key :single_line_items, :variants
    add_foreign_key :single_line_items, :single_order_details
  end
end

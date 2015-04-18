class CreateOneClickItems < ActiveRecord::Migration
  def change
    create_table :one_click_items do |t|
      t.references :variant, index: true
      t.references :purchase_order, index: true
      t.integer :quantity
      t.integer :price
      t.integer :tax_rate_id
      t.integer :additional_tax_total

      t.timestamps null: false
    end
  end
end

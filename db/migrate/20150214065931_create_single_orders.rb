class CreateSingleOrders < ActiveRecord::Migration
  def change
    create_table :single_orders do |t|
      t.references :purchase_order, index: true

      t.timestamps null: false
    end
    add_foreign_key :single_orders, :purchase_orders
  end
end

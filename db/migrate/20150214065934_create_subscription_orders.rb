class CreateSubscriptionOrders < ActiveRecord::Migration
  def change
    create_table :subscription_orders do |t|
      t.references :purchase_order, index: true
      t.references :variant, index: true

      t.timestamps null: false
    end
    add_foreign_key :subscription_orders, :purchase_orders
    add_foreign_key :subscription_orders, :variants
  end
end

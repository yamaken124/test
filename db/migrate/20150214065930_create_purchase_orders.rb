class CreatePurchaseOrders < ActiveRecord::Migration
  def change
    create_table :purchase_orders do |t|
      t.references :user, index: true
      t.integer :state

      t.timestamps null: false
    end
    add_foreign_key :purchase_orders, :users
  end
end

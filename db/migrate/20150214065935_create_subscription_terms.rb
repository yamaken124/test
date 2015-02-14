class CreateSubscriptionTerms < ActiveRecord::Migration
  def change
    create_table :subscription_terms do |t|
      t.references :subscription_order, index: true
      t.integer :term
      t.integer :interval
      t.integer :interval_unit

      t.timestamps null: false
    end
    add_foreign_key :subscription_terms, :subscription_orders
  end
end

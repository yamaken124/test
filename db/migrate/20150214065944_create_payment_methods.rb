class CreatePaymentMethods < ActiveRecord::Migration
  def change
    create_table :payment_methods do |t|
      t.string :name
      t.text :description
      t.string :environment
      t.datetime :is_valid_at
      t.datetime :is_invalid_at

      t.timestamps null: false
    end
  end
end

class CreateBillsPayments < ActiveRecord::Migration
  def change
    create_table :bills_payments do |t|
      t.references :bill, index: true
      t.references :payment, index: true

      t.timestamps null: false
    end
    add_foreign_key :bills_payments, :bills
    add_foreign_key :bills_payments, :payments
  end
end

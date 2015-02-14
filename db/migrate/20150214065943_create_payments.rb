class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :amount
      t.integer :used_point
      t.integer :payment_method_id

      t.timestamps null: false
    end
  end
end

class CreateOneClickPayments < ActiveRecord::Migration
  def change
    create_table :one_click_payments do |t|

      t.integer :amount
      t.integer :source_id
      t.string :source_type
      t.string :gmo_access_id
      t.string :gmo_access_pass
      t.integer :gmo_card_seq_temporary
      t.integer :used_point, null: false, default: 0
      t.integer :payment_method_id
      t.references :address, index: true
      t.references :one_click_item, index: true
      t.string :number
      t.integer :user_id

      t.timestamps null: false
    end
  end
end

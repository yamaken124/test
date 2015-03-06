class CreateCreditCard < ActiveRecord::Migration
  def change
    create_table :credit_cards do |t|
      t.integer :month
      t.integer :year
      t.string :cc_type
      t.string :last_digits
      t.string :name
      t.references :user, index: true
      t.integer :payment_method_id
      t.timestamps null: false
    end
    add_foreign_key :credit_cards, :users
  end
end

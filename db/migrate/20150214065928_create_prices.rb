class CreatePrices < ActiveRecord::Migration
  def change
    create_table :prices do |t|
      t.references :variant, index: true
      t.integer :amount

      t.timestamps null: false
    end
    add_foreign_key :prices, :variants
  end
end

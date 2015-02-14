class CreateVariants < ActiveRecord::Migration
  def change
    create_table :variants do |t|
      t.string :sku
      t.references :product, index: true
      t.datetime :is_valid_at
      t.datetime :is_invalid_at

      t.timestamps null: false
    end
    add_foreign_key :variants, :products
  end
end

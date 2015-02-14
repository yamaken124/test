class CreateTaxRates < ActiveRecord::Migration
  def change
    create_table :tax_rates do |t|
      t.decimal :amount
      t.datetime :is_valid_at
      t.datetime :is_invalid_at

      t.timestamps null: false
    end
  end
end

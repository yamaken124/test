class CreateBills < ActiveRecord::Migration
  def change
    create_table :bills do |t|
      t.references :address, index: true
      t.integer :item_total
      t.integer :total
      t.integer :shipment_total
      t.integer :additional_tax_total
      t.integer :used_point

      t.timestamps null: false
    end
    add_foreign_key :bills, :addresses
  end
end

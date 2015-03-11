class CreateShipments < ActiveRecord::Migration
  def change
    create_table :shipments do |t|
      t.references :payment, index: true
      t.references :address, index: true
      t.datetime :shopped_at
      t.integer :state

      t.timestamps null: false
    end
    add_foreign_key :shipments, :payments
    add_foreign_key :shipments, :addresses
  end
end

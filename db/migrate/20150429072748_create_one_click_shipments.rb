class CreateOneClickShipments < ActiveRecord::Migration
  def change
    create_table :one_click_shipments do |t|
      t.references :address, index: true
      t.references :one_click_item, index: true
      t.string :tracking
      t.datetime :shipped_at
      t.integer :state

      t.timestamps null: false
    end
  end
end

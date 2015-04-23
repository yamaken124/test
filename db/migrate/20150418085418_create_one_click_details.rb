class CreateOneClickDetails < ActiveRecord::Migration
  def change
    create_table :one_click_details do |t|
      t.integer :item_total, null: false, default: 0
      t.references :tax_rate, index: true
      t.integer :included_tax_total
      t.integer :total, null: false, default: 0
      t.integer :paid_total
      t.date :completed_on
      t.datetime :completed_at
      t.references :address
      t.integer :additional_tax_total, null: false, default: 0
      t.integer :used_point, default: 0
      t.integer :adjustment_total, null: false, default: 0
      t.integer :item_count, null: false, default: 0

      t.timestamps null: false
    end
  end
end

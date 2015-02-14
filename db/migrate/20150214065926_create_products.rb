class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.datetime :is_valid_at
      t.datetime :is_invalid_at

      t.timestamps null: false
    end
  end
end

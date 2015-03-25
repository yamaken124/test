class CreateReturnedItems < ActiveRecord::Migration
  def change
    create_table :returned_items do |t|
      t.integer :single_line_item_id, null: false
      t.integer :user_id, null: false
      t.text :message

      t.timestamps null: false
    end
    add_index :returned_items, :single_line_item_id, unique: true
    add_index :returned_items, :user_id

    add_foreign_key :returned_items, :single_line_items
    add_foreign_key :returned_items, :users
  end
end

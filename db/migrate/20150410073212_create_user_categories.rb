class CreateUserCategories < ActiveRecord::Migration
  def change
    create_table :user_categories do |t|
      t.string :name
      t.timestamps null: false
    end
  end
end

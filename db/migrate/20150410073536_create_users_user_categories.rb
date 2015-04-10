class CreateUsersUserCategories < ActiveRecord::Migration
  def change
    create_table :users_user_categories do |t|
      t.references :user, index: true
      t.references :user_category, index: true

      t.timestamps null: false
    end
  end
end

class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.references :user, index: true
      t.string :last_name, default: '', null: false
      t.string :first_name, default: '', null: false
      t.string :last_name_kana, default: '', null: false
      t.string :first_name_kana, default: '', null: false
      t.string :phone, default: '', null: false
      t.timestamps null: false
    end
    add_foreign_key :profiles, :users
  end
end

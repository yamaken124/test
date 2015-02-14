class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.references :user, index: true
      t.string :last_name
      t.string :first_name
      t.string :address
      t.string :city
      t.string :zipcode
      t.string :phone
      t.string :alternative_phone

      t.timestamps null: false
    end
    add_foreign_key :addresses, :users
  end
end

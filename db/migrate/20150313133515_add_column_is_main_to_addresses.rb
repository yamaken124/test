class AddColumnIsMainToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :is_main, :boolean, default: false, null: false, after: :alternative_phone
  end
end

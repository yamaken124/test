class AddColumnActiveFlgToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :is_deleted, :boolean, null: false, default: false
  end
end

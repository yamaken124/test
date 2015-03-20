class AddColumnIsActiveToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :is_active, :boolean, null: false, default: true, after: :is_main
  end
end

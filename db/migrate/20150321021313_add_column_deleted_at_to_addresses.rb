class AddColumnDeletedAtToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :deleted_at, :datetime, after: :is_main
  end
end

class AddColumnReturnedAtToReturnedItems < ActiveRecord::Migration
  def change
    add_column :returned_items, :returned_at, :datetime, after: :message
  end
end

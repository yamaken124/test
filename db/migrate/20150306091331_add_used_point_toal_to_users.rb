class AddUsedPointToalToUsers < ActiveRecord::Migration
  def change
    add_column :users, :used_point_total, :integer, null: false, default: 0
  end
end

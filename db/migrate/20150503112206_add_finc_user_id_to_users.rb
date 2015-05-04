class AddFincUserIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :finc_user_id, :integer
  end
end

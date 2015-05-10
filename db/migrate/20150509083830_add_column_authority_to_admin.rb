class AddColumnAuthorityToAdmin < ActiveRecord::Migration
  def change
    add_column :admins, :authority, :integer, after: :last_sign_in_ip
  end
end

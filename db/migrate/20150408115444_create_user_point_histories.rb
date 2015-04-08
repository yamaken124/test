class CreateUserPointHistories < ActiveRecord::Migration
  def change
    create_table :user_point_histories do |t|
      t.references :user, index: true
      t.integer :used_point

      t.timestamps null: false
    end
  end
end

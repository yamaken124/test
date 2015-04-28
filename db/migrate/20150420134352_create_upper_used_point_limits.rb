class CreateUpperUsedPointLimits < ActiveRecord::Migration
  def change
    create_table :upper_used_point_limits do |t|

      t.references :variant, index: true
      t.integer :limit, null: false

      t.timestamps null: false
    end
  end
end

class ChangeDatatypeImageableTypeOfImages < ActiveRecord::Migration
  def change
    change_column :images, :imageable_type, :integer
  end
end

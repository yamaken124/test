class RenamePositonToPosition < ActiveRecord::Migration
  def up
    rename_column :taxons, :positon, :position
  end

  def down
    rename_column :taxons, :position, :positon
  end
end

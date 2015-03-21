class DropTableTaxonomies < ActiveRecord::Migration
  def change
    drop_table :taxonomies
  end
end

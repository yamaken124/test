class DeleteColumnTaxonomyIdOfTaxons < ActiveRecord::Migration
  def change

    remove_column :taxons, :taxonomy_id, :integer

  end
end

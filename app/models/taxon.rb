# == Schema Information
#
# Table name: taxons
#
#  id          :integer          not null, primary key
#  parent_id   :integer
#  positon     :integer
#  name        :string(255)
#  permalink   :string(255)
#  taxonomy_id :integer
#  description :text(65535)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Taxon < ActiveRecord::Base

  acts_as_nested_set

  belongs_to :taxonomy
  belongs_to :parent, class_name: 'Taxon'

  def self.leaf_taxons
    taxons = Taxon.where.not(id: Taxon.pluck(:parent_id))
  end

end

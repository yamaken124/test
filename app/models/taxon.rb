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
  has_many :products_taxon

  acts_as_nested_set parent_column: :parent_id, left_column: :lft, right_column: :rgt

  belongs_to :parent, class_name: 'Taxon'

end

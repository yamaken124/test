class Taxon < ActiveRecord::Base
  belongs_to :taxonomy
  belongs_to :parent, class_name: 'Taxon'
end

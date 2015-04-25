class VariantImageWhereabout < ActiveRecord::Base

  belongs_to :image#, ->(record) { where(imageable_type: "Variant") }
  belongs_to :variant
  validates :whereabout, :presence => true

  enum whereabout: { top: 1, description: 2}

end

class Variant < ActiveRecord::Base
  belongs_to :product
  has_many   :single_line_items
  has_many   :prices
end

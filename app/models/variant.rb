class Variant < ActiveRecord::Base
  belongs_to :product
  has_many :price
end
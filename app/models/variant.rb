class Variant < ActiveRecord::Base
  belongs_to :product
  has_many :prices
end
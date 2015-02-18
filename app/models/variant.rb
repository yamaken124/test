class Variant < ActiveRecord::Base
  belongs_to :product
  has_many :prices

enum order_type: {single_order: 1, subscription_order: 2}
end
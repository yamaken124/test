class Variant < ActiveRecord::Base
  belongs_to :product
  has_many :prices

  enum order_type: {subscription_order: 1, single_order: 2}
end
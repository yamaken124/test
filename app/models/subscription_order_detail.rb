class SubscriptionOrderDetail < ActiveRecord::Base
  belongs_to :subscription_order
  belongs_to :address
  belongs_to :tax_rate
end

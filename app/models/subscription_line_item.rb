class SubscriptionLineItem < ActiveRecord::Base
  belongs_to :variant
  belongs_to :subscription_order_detail
  belongs_to :tax_rate
end

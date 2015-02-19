class SubscriptionOrder < ActiveRecord::Base
  belongs_to :purchase_order
  belongs_to :variant
  has_many :subscription_order_details
end

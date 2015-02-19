class SubscriptionOrderDetail < ActiveRecord::Base
  belongs_to :subscription_order
  belongs_to :address
  belongs_to :tax_rate
  has_many   :bills_order_details, as: :order_detail
  has_many   :bills, through: :bills_order_details
end

# == Schema Information
#
# Table name: subscription_orders
#
#  id                :integer          not null, primary key
#  purchase_order_id :integer
#  variant_id        :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class SubscriptionOrder < ActiveRecord::Base
  belongs_to :purchase_order
  belongs_to :variant
  has_many :subscription_order_details
end

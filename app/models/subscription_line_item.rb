# == Schema Information
#
# Table name: subscription_line_items
#
#  id                           :integer          not null, primary key
#  variant_id                   :integer
#  subscription_order_detail_id :integer
#  quantity                     :integer
#  price                        :integer
#  tax_rate_id                  :integer
#  additional_tax_total         :integer
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#

class SubscriptionLineItem < ActiveRecord::Base
  belongs_to :variant
  belongs_to :subscription_order_detail
  # belongs_to :tax_rate
end

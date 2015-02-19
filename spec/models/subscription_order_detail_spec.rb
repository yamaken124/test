# == Schema Information
#
# Table name: subscription_order_details
#
#  id                     :integer          not null, primary key
#  subscription_order_id  :integer
#  number                 :string(255)
#  item_total             :integer
#  total                  :integer
#  completed_at           :datetime
#  address_id             :integer
#  shipment_total         :integer
#  additional_tax_total   :integer
#  confirmation_delivered :boolean
#  guest_token            :string(255)
#  adjustment_total       :integer
#  item_count             :integer
#  date                   :date
#  lock_version           :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

require 'rails_helper'

RSpec.describe SubscriptionOrderDetail, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

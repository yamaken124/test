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

require 'rails_helper'

RSpec.describe SubscriptionOrder, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

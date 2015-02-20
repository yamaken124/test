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

FactoryGirl.define do
  factory :subscription_order do
    purchase_order nil
variant nil
  end

end

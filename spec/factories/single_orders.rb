# == Schema Information
#
# Table name: single_orders
#
#  id                :integer          not null, primary key
#  purchase_order_id :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

FactoryGirl.define do
  factory :single_order do
    purchase_order nil
  end

end

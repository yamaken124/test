# == Schema Information
#
# Table name: bills
#
#  id                     :integer          not null, primary key
#  single_order_detail_id :integer
#  address_id             :integer
#  item_total             :integer
#  total                  :integer
#  shipment_total         :integer
#  additional_tax_total   :integer
#  used_point             :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

FactoryGirl.define do
  factory :bill do
    address nil
item_total 1
total 1
shipment_total 1
additional_tax_total 1
used_point 1
  end

end

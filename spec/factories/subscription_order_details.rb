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

FactoryGirl.define do
  factory :subscription_order_detail do
    subscription_order nil
number "MyString"
item_total 1
total 1
completed_at "2015-02-14 15:59:32"
address nil
shipment_total 1
additional_tax_total 1
confirmation_delivered false
guest_token "MyString"
adjustment_total 1
item_count 1
date "2015-02-14"
lock_version 1
  end

end

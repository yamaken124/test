# == Schema Information
#
# Table name: single_order_details
#
#  id                   :integer          not null, primary key
#  single_order_id      :integer
#  item_total           :integer          default(0), not null
#  tax_rate_id          :integer
#  total                :integer          default(0), not null
#  paid_total           :integer
#  completed_on         :date
#  completed_at         :datetime
#  address_id           :integer
#  shipment_total       :integer          default(0), not null
#  additional_tax_total :integer          default(0), not null
#  used_point           :integer          default(0)
#  adjustment_total     :integer          default(0), not null
#  item_count           :integer          default(0), not null
#  lock_version         :integer          default(0), not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

FactoryGirl.define do
  factory :single_order_detail do
    single_order_id nil
    item_total 1
    total 1
    completed_on "2015-02-14"
    completed_at "2015-02-14 15:59:30"
    address nil
    shipment_total 1
    additional_tax_total 1
    adjustment_total 1
    item_count 1
    lock_version 1
  end

end

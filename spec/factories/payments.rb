# == Schema Information
#
# Table name: payments
#
#  id                :integer          not null, primary key
#  amount            :integer
#  used_point        :integer
#  payment_method_id :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

FactoryGirl.define do
  factory :payment do
    amount 1
    used_point 1
    payment_method_id 1
  end
end

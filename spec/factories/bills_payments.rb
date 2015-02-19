# == Schema Information
#
# Table name: bills_payments
#
#  id         :integer          not null, primary key
#  bill_id    :integer
#  payment_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :bills_payment do
    bill nil
payment nil
  end

end

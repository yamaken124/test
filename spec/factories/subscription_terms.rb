# == Schema Information
#
# Table name: subscription_terms
#
#  id                    :integer          not null, primary key
#  subscription_order_id :integer
#  term                  :integer
#  interval              :integer
#  interval_unit         :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

FactoryGirl.define do
  factory :subscription_term do
    subscription_order nil
term 1
interval 1
interval_unit 1
  end

end

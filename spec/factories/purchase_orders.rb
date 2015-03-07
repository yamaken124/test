# == Schema Information
#
# Table name: purchase_orders
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  state      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :purchase_order do
    user nil
  end

end

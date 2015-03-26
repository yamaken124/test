# == Schema Information
#
# Table name: payments
#
#  id                     :integer          not null, primary key
#  amount                 :integer
#  source_id              :integer
#  source_type            :string(255)
#  gmo_access_id          :string(255)
#  gmo_access_pass        :string(255)
#  gmo_card_seq_temporary :integer
#  used_point             :integer          default(0), not null
#  payment_method_id      :integer
#  address_id             :integer
#  single_order_detail_id :integer
#  number                 :string(255)
#  user_id                :integer
#  state                  :integer          default(0)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

FactoryGirl.define do
  factory :payment do
    amount 1
    used_point 1
    payment_method_id 1
  end
end

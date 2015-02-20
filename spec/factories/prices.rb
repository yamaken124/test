# == Schema Information
#
# Table name: prices
#
#  id         :integer          not null, primary key
#  variant_id :integer
#  amount     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :price do
    variant nil
amount 1
  end

end

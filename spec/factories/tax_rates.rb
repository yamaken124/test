# == Schema Information
#
# Table name: tax_rates
#
#  id            :integer          not null, primary key
#  amount        :decimal(6, 5)
#  is_valid_at   :datetime
#  is_invalid_at :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

FactoryGirl.define do
  factory :tax_rate do
    amount "9.99"
is_valid_at "2015-02-14 15:59:28"
is_invalid_at "2015-02-14 15:59:28"
  end

end

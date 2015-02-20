# == Schema Information
#
# Table name: variants
#
#  id            :integer          not null, primary key
#  sku           :string(255)
#  product_id    :integer
#  is_valid_at   :datetime
#  is_invalid_at :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

FactoryGirl.define do
  factory :variant do
    sku "MyString"
    # product_id "10"
    # is_valid_at "2015-02-14 15:59:27"
    # is_invalid_at "2015-02-14 15:59:27"
  end

end

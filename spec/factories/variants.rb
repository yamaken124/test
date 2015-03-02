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

    sku "all"
    is_valid_at Date.yesterday
    is_invalid_at Date.tomorrow
    order_type "single_order"

    factory :expired_variant do
      is_invalid_at Date.yesterday
    end

    factory :preparing_variant do
      is_valid_at Date.tomorrow
    end

  end

end
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
    name "Mystring"
    is_valid_at Time.now.last_month
    is_invalid_at Time.now.next_month
    order_type "single_order"

    factory :expired_variant do
      is_invalid_at Time.now.last_month
    end

    factory :preparing_variant do
      is_valid_at Time.now.next_month
    end

    factory :single_variant do
      order_type "single_order"
    end

    factory :subscription_variant do
      order_type "subscription_order"
    end

  end

end
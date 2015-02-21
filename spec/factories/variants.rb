FactoryGirl.define do
  factory :variant do
    sku "MyString"
    is_valid_at Date.yesterday
    is_invalid_at Date.tomorrow
    order_type "single_order"

    factory :invalid_variant do
      is_valid_at Date.yesterday
    end
  end

end
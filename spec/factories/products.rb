FactoryGirl.define do
  factory :product do
    name "MyString"
    description "MyText"
    is_valid_at Date.yesterday
    is_invalid_at Date.tomorrow

    factory :invalid_product do
      is_valid_at Date.tomorrow
    end
  end
end
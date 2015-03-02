# == Schema Information
#
# Table name: products
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  description   :text(65535)
#  is_valid_at   :datetime
#  is_invalid_at :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

FactoryGirl.define do

  factory :product do

    name "MyString"
    description "MyText"
    is_valid_at Date.yesterday
    is_invalid_at Date.tomorrow

    factory :expired_product do
      is_invalid_at Date.yesterday
    end

    factory :preparing_product do
      is_valid_at Date.tomorrow
    end

  end

end
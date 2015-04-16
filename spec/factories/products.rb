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
    is_valid_at Time.now.last_month
    is_invalid_at Time.now.next_month

    factory :expired_product do
      is_invalid_at Date.yesterday
    end

    factory :preparing_product do
      is_valid_at Date.tomorrow
    end

  end

end
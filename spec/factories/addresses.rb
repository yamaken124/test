# == Schema Information
#
# Table name: addresses
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  last_name         :string(255)
#  first_name        :string(255)
#  address           :string(255)
#  city              :string(255)
#  zipcode           :string(255)
#  phone             :string(255)
#  alternative_phone :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

FactoryGirl.define do
  factory :address do
    last_name "MyString"
    first_name "MyString"
    address "MyString"
    city "MyString"
    zipcode "MyString"
    phone "MyString"
    alternative_phone "MyString"
    is_main false
  end

end

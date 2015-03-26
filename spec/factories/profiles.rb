# == Schema Information
#
# Table name: profiles
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  last_name       :string(255)      default(""), not null
#  first_name      :string(255)      default(""), not null
#  last_name_kana  :string(255)      default(""), not null
#  first_name_kana :string(255)      default(""), not null
#  phone           :string(255)      default(""), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

FactoryGirl.define do
  factory :profile do
    last_name "MyString"
    first_name "MyString"
    last_name_kana "MyString"
    first_name_kana "MyString"
    phone "xxxxx"
    user nil
  end
end

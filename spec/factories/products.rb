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
is_valid_at "2015-02-14 15:59:26"
is_invalid_at "2015-02-14 15:59:26"
  end

end

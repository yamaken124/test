# == Schema Information
#
# Table name: payment_methods
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  description   :text(65535)
#  environment   :string(255)
#  is_valid_at   :datetime
#  is_invalid_at :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

FactoryGirl.define do
  factory :payment_method do
    name "MyString"
description "MyText"
environment "MyString"
is_valid_at "2015-02-14 15:59:36"
is_invalid_at "2015-02-14 15:59:36"
  end

end

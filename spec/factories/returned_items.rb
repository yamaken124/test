# == Schema Information
#
# Table name: returned_items
#
#  id                  :integer          not null, primary key
#  single_line_item_id :integer          not null
#  user_id             :integer          not null
#  message             :text(65535)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

FactoryGirl.define do
  factory :returned_item do
    single_line_item 1
user_id 1
message "MyText"
  end

end

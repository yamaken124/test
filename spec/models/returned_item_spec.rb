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

require 'rails_helper'

RSpec.describe ReturnedItem, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: single_line_items
#
#  id                     :integer          not null, primary key
#  variant_id             :integer
#  single_order_detail_id :integer
#  quantity               :integer
#  price                  :integer
#  tax_rate_id            :integer
#  additional_tax_total   :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

require 'rails_helper'

RSpec.describe SingleLineItem, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

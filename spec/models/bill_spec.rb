# == Schema Information
#
# Table name: bills
#
#  id                     :integer          not null, primary key
#  single_order_detail_id :integer
#  address_id             :integer
#  item_total             :integer
#  total                  :integer
#  shipment_total         :integer
#  additional_tax_total   :integer
#  used_point             :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

require 'rails_helper'

RSpec.describe Bill, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

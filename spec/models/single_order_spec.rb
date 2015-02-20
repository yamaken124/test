# == Schema Information
#
# Table name: single_orders
#
#  id                :integer          not null, primary key
#  purchase_order_id :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'rails_helper'

RSpec.describe SingleOrder, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

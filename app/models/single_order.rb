# == Schema Information
#
# Table name: single_orders
#
#  id                :integer          not null, primary key
#  purchase_order_id :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class SingleOrder < ActiveRecord::Base
  belongs_to :purchase_order
  has_one    :single_order_detail

  accepts_nested_attributes_for :single_order_detail
end

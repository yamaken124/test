class SingleOrderDetail < ActiveRecord::Base
  belongs_to :single_order
  belongs_to :address
  belongs_to :tax_rate
  has_many :bills, as: :order_detail
  has_many   :single_line_items

  accepts_nested_attributes_for :single_line_items
end

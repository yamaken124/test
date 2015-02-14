class BillsOrderDetail < ActiveRecord::Base
  belongs_to :bill
  belongs_to :order_detail, polymorphic: true
end

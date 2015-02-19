class SingleOrder < ActiveRecord::Base
  belongs_to :purchase_order
  has_one    :single_order_detail

  accepts_nested_attributes_for :single_order_detail
end

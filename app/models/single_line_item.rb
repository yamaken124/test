class SingleLineItem < ActiveRecord::Base
  belongs_to :variant
  belongs_to :single_order_detail
  belongs_to :tax_rate
end

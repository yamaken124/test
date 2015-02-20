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

class SingleLineItem < ActiveRecord::Base
  belongs_to :variant
  belongs_to :single_order_detail
  belongs_to :tax_rate
end

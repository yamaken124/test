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


  def find_line_item_by_variant(variant, options = {})                                                                                                  
    single_order_detail.single_line_items.detect { |line_item|
      line_item.variant_id == variant.id &&
        line_item_options_match(line_item, options)
    }
  end

  def line_item_options_match(line_item, options)                                                                                                       
    return true unless options

    self.line_item_comparison_hooks.all? { |hook|
      self.send(hook, line_item, options)
    }
  end

  def ensure_updated_shipments
    # if shipments.any? && !self.completed?
      # self.shipments.destroy_all
      # self.update_column(:shipment_total, 0)
      # restart_checkout_flow
    # end
  end

  class_attribute :line_item_comparison_hooks
  self.line_item_comparison_hooks = Set.new
end

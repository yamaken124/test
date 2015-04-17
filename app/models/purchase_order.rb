# == Schema Information
#
# Table name: purchase_orders
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  state      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class PurchaseOrder < ActiveRecord::Base
  include PurchaseOrder::Transition
  include PurchaseOrder::Checkout
  include PurchaseOrder::Point

  belongs_to :user
  has_one    :single_order
  has_one    :single_order_detail, through: :single_order
  has_many   :single_line_items, through: :single_order_detail
  has_many   :subscription_orders
  has_many   :subscription_order_details, through: :subscription_orders
  has_many   :variants, through: :single_line_items

  accepts_nested_attributes_for :single_order

  def self.incomplete
    PurchaseOrder.where.not(id: (PurchaseOrder.complete.pluck(:id) + PurchaseOrder.fail.pluck(:id)) )
  end

  def completed?
    complete?
  end

  def can_go_to_state?(state)
    return false unless has_checkout_step?(self.state) && has_checkout_step?(state)
    checkout_step_index(state) > checkout_step_index(self.state)
  end

  # Associates the specified user with the order.
  def associate_user!(user)
    self.user = user
    attrs_to_set = { user_id: user.id }
    assign_attributes(attrs_to_set)

    if persisted?
      # immediately persist the changes we just made, but don't use save since we might have an invalid address associated
      self.class.unscoped.where(id: id).update_all(attrs_to_set)
    end
  end

  def checkout_allowed?
    # TODO check line_items line_items.count > 0
    true
  end

  def single_order_contents
    @single_order_contents ||= SingleOrderContents.new(self)
  end

  def single_order_detail
    @single_order_detail ||= single_order_contents.detail
  end

  def find_line_item_by_variant(variant, options = {})
    single_order.single_order_detail.single_line_items.detect { |line_item|
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

  class_attribute :line_item_comparison_hooks
  self.line_item_comparison_hooks = Set.new
end

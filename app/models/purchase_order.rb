class PurchaseOrder < ActiveRecord::Base
  include PurchaseOrder::Checkout

  belongs_to :user
  has_one    :single_order
  has_many   :subscription_orders
  has_many   :subscription_order_details, through: :subscription_orders

  accepts_nested_attributes_for :single_order 

  enum state: { cart: 0, payment: 10, confirm: 20, complete: 30 }

  def self.incomplete
    PurchaseOrder.where.not(id: PurchaseOrder.complete.pluck(:id))
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

  def contents                                                                                                                                          
    @contents ||= OrderContents.new(self)
  end

  def single_contents
    @contents ||= SingleOrderContents.new(self)
  end
end

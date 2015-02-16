class PurchaseOrder < ActiveRecord::Base
  belongs_to :user

  enum state: { payment: 10, confirm: 20, complete: 30 }

  def self.incomplete
    PurchaseOrder.where(id: PurchaseOrder.complete.pluck(:id))
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
end

class OneClickPayment < ActiveRecord::Base

  belongs_to :payment_method
  belongs_to :address
  belongs_to :user
  belongs_to :one_click_detail

  include AASM

  enum state: {
    checkout: 0, completed: 10, processing: 20, pending: 30, failed: 40, canceled: 50
  }

  aasm column: :state do
    state :checkout, initial: true
    state :processing
    state :pending
    state :failed
    state :completed
    state :canceled

    event :processing, after: :pay_with_gmo_payment do
      transitions from: :checkout, to: :processing
    end

    event :completed, after: [:update_user_used_point] do
      transitions from: [:processing, :pending], to: :completed
    end

    event :pending do
      transitions from: :processing , to: :pending
    end

    event :failed do
      transitions from: [:pending, :processing, :checkout], to: :failed
    end

    event :canceled, after: :cancel_order do
      transitions from: :completed, to: :canceled
    end

  end

  def pay_with_gmo_payment #FIXME concern model
    access = GmoMultiPayment::Transaction.new(self).sales_entry
    self.gmo_access_id = access[:access_id]
    self.gmo_access_pass = access[:access_pass]
    return GmoMultiPayment::Transaction.new(self).exec(self.gmo_card_seq_temporary)
  end

  def cancel_order
    return if self.gmo_access_id.nil? #0円決済のcancel
    raise unless GmoMultiPayment::Transaction.new(self).transaction_void
    user.update_used_point_total( (-1)*self.one_click_detail.used_point )
    self.one_click_detail.update!(paid_total: 0, used_point: 0)
  end

  def update_user_used_point
    user.update_used_point_total(self.used_point)
  end

end

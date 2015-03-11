class Shipment < ActiveRecord::Base
  belongs_to :payment
  belongs_to :address

  include AASM

  enum state: { pending: 0, ready: 10, shipped: 20, canceled: 30 }

  aasm column: :state do
    state :pending, initial: true
    state :ready
    state :shipped
    state :canceled

    event :ready do
      transitions from: :pending, to: :ready
    end

    event :shipped  do
      transitions from: [:ready, :pending], to: :shipped
    end

    event :pending do
      transitions from: :ready , to: :pending
    end

    event :canceled do
      transitions from: :shipped, to: :canceled
    end
  end

end

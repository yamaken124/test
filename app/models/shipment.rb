# == Schema Information
#
# Table name: shipments
#
#  id         :integer          not null, primary key
#  payment_id :integer
#  address_id :integer
#  tracking   :string(255)
#  shipped_at :datetime
#  state      :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

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
      transitions from: [:pending, :shipped], to: :ready
    end

    event :shipped, after: [:register_shipped_at]  do
      transitions from: [:ready, :pending], to: :shipped
    end

    event :pending do
      transitions from: :ready , to: :pending
    end

    event :canceled do
      transitions from: [:pending, :ready, :shipped], to: :canceled
    end
  end

  def self.transitionable_states
    ['ready', 'shipped', 'canceled']
  end

  def register_shipped_at
    self.update(shipped_at: Time.now)
  end

end

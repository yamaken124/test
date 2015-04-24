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
  belongs_to :single_line_item
  belongs_to :address

  include AASM

  enum state: { pending: 0, ready: 10, shipped: 20, canceled: 30, returned: 40 }

  aasm column: :state do
    state :pending, initial: true
    state :ready
    state :shipped
    state :canceled
    state :returned

    event :ready do
      transitions from: [:pending], to: :ready
    end

    event :shipped, after: [:register_shipped_at]  do
      transitions from: [:ready, :pending], to: :shipped
    end

    event :pending do
      transitions from: :ready , to: :pending
    end

    event :canceled do
      transitions from: [:pending, :ready], to: :canceled
    end

    event :returned do
      transitions from: :shipped, to: :returned
    end
  end

  def self.transitionable_states
    ['ready', 'shipped', 'canceled', 'returned']
  end

  def register_shipped_at
    self.update(shipped_at: Time.now)
  end

  def self.all_state?(shipments, state) #限られたitemだけの評価をadmin/shipmentから行う
    shipments.all? {|shipment| (shipment.state == "#{state}")}
  end

  # def self.all_shipped?(shipments) #限られたitemだけの評価をadmin/shipmentから行う
  #   shipments.all? {|shipment| shipment.shipped?}
  # end

  # def self.all_canceled?(shipments)
  #   shipments.all? {|shipment| shipment.canceled?}
  # end

  # def self.all_ready?(shipments)
  #   shipments.all? {|shipment| shipment.ready?}
  # end

end

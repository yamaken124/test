class PurchaseOrder < ActiveRecord::Base
  module Transition
    def self.included(klass)
      klass.class_eval do
        include AASM

        enum state: {
          cart: 0, payment: 10, confirm: 20, complete: 30
        }

        aasm column: :state do
          state :cart, initial: true
          state :payment
          state :confirm
          state :complete

          event :cart do
            transitions from: [:payment, :confirm], to: :cart
          end

          event :payment do
            transitions from: [:cart, :confirm], to: :payment
          end

          event :confirm do
            transitions from: :payment, to: :confirm
          end

          event :complete do
            transitions from: :confirm, to: :complete
          end
        end
      end
    end
  end
end

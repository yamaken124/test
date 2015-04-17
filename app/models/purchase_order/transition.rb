class PurchaseOrder < ActiveRecord::Base
  module Transition
    def self.included(klass)
      klass.class_eval do
        include AASM

        enum state: {
          cart: 0, payment: 10, confirm: 20, complete: 30, fail: 40
        }

        aasm column: :state do
          state :cart, initial: true
          state :payment
          state :confirm
          state :complete
          state :fail

          event :cart do
            transitions from: [:payment, :confirm], to: :cart
          end

          event :payment do
            transitions from: [:cart, :confirm], to: :payment
          end

          event :confirm do
            transitions from: :payment, to: :confirm
          end

          event :complete, after: :update_address_is_main  do
            transitions from: :confirm, to: :complete
          end

          event :fail, after: :fail_payment do
            transitions from: [:payment,:confirm,:complete], to: :fail
          end
        end

        def update_address_is_main
          return if !single_order || !single_order.single_order_detail
          address = single_order.single_order_detail.address
          unless address.is_main
            ActiveRecord::Base.transaction do
              user.addresses.update_all(is_main: false)
              address.update(is_main: true)
            end
          end
        end

        def fail_payment
          single_order_detail.payment.failed! if single_order_detail.payment.present?
        end

      end
    end
  end
end

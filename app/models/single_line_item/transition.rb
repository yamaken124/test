class SingleLineItem < ActiveRecord::Base
  module Transition
    def self.included(klass)
      klass.class_eval do
        include AASM

        enum payment_state: {
          checkout: 0, completed: 10, pending: 20, failed: 30, canceled: 40
        }

        aasm column: :payment_state do
          state :checkout, initial: true
          state :processing
          state :pending
          state :failed
          state :completed
          state :canceled

         event :completed do
            transitions from: [:checkout, :pending], to: :completed
          end

          event :canceled, after: :change_paid_amount do
            transitions from: [:completed, :checkout, :canceled], to: :canceled
          end

        end

        def change_paid_amount
          detail = self.single_order_detail
          unless detail.payment.canceled?
            OrderUpdater.new(detail).calculate_paid_total(self)
            detail.reload
            raise unless GmoMultiPayment::Transaction.new(detail.payment).sales_change(detail.paid_total)
          end
        end

      end
    end
  end
end

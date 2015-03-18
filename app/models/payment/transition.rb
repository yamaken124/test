class Payment < ActiveRecord::Base
  module Transition
    def self.included(klass)
      klass.class_eval do
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

          event :completed, after: [:register_shipment, :set_dealed_datetime] do
            transitions from: [:processing, :pending], to: :completed
          end

          event :pending do
            transitions from: :processing , to: :pending
          end

          event :failed do
            transitions from: :pending, to: :failed
          end

          event :canceled, after: :cancel_order do
            transitions from: :completed, to: :canceled
          end

        end

        def pay_with_gmo_payment
          access = GmoMultiPayment::Transaction.new(self).sales_entry
          self.gmo_access_id = access[:access_id]
          self.gmo_access_pass = access[:access_pass]
          return GmoMultiPayment::Transaction.new(self).exec(self.gmo_card_seq_temporary)
        end

        def register_shipment
          Shipment.new(set_shipment_params).save!
        end

        def set_dealed_datetime
          order_detail = SingleOrderDetail.find(self.single_order_detail)
          order_detail.update(completed_at: Time.now)
        end

        def cancel_order
          raise unless GmoMultiPayment::Transaction.new(self).transaction_void
        end

      end
    end
  end
end

class Payment < ActiveRecord::Base
  module Transition
    def self.included(klass)
      klass.class_eval do
        include AASM

        enum state: {
          checkout: 0, completed: 10, processing: 20, pending: 30, failed: 40
        }

        aasm column: :state do
          state :checkout, initial: true
          state :processing
          state :pending
          state :failed
          state :completed

          event :processing, after: :pay_with_gmo_payment do
            transitions from: :checkout, to: :processing
          end

          event :completed do
            transitions from: [:processing, :pending], to: :completed
          end

          event :pending do
            transitions from: :processing , to: :pending
          end

          event :failed do
            transitions from: :pending, to: :failed
          end

        end

        def pay_with_gmo_payment
          # puts aasm.to_state
        end
      end
    end
  end
end

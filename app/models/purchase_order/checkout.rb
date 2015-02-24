class PurchaseOrder < ActiveRecord::Base
  module Checkout
    def self.included(klass)
      klass.class_eval do
        class_attribute :checkout_flow
        class_attribute :checkout_steps

        def has_checkout_step?(step)
          step.present? && self.checkout_steps.include?(step)
        end

        def checkout_steps
          steps = self.class.checkout_steps.each_with_object([]) { |(step, options), checkout_steps|
            next if options.include?(:if) && !options[:if].call(self)
            checkout_steps << step
          }.map(&:to_s)

          # Ensure there is always a complete step
          steps << "complete" unless steps.include?("complete")
          steps
        end

        def self.checkout_steps
          @checkout_steps ||= { payment: {}, confirm: {}, complete: {} }
        end

        def self.checkout_step_index(step)
          self.checkout_steps.index(step).to_i
        end

        def checkout_step_index(step)
          self.checkout_steps.index(step).to_i
        end

        def valid_state?(step)
          checkout_steps.include? step.to_s
        end

        def next_state
          next_step = checkout_steps[checkout_step_index(state) + 1]
          if valid_state?(next_step)
            send("#{next_step}!")
            true
          else
            false
          end
        end

        define_callbacks :updating_from_params, terminator: ->(target, result) { result == false }

        set_callback :updating_from_params, :before, :update_params_payment_source

        def update_from_params(params, permitted_params, request_env = {})
          @updating_params = params

          begin
            ActiveRecord::Base.transaction do
              # TODO shipment

              point = \
                if params[:order] && params[:order][:used_point]
                  raise unless valid_point?(params[:order][:used_point])
                  params[:order][:order][:used_point]
                else
                  0
                end
              # TODO update adjustment

              raise unless single_bill.update_bill({used_point: point})
              raise unless next_state
              self.reload
            end
            true
          rescue
            false
          end
        end
      end
    end
  end
end

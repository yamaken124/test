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
              attributes = @updating_params[:order] ? @updating_params[:order].permit(permitted_params).delete_if { |k, v| v.nil? } : {}
              case "#{params[:state]}".to_sym

              when :payment
                attributes[:total] = OrderUpdater.new(single_order_detail).update_totals
                attributes[:payment_attributes] = attributes[:payment_attributes].merge(payment_attributes_from_params(single_order_detail,attributes))
                if attributes[:used_point] && !valid_point?(attributes[:used_point].to_i)
                  if !point_smaller_than_price?(attributes[:total]) || !valid_payment_attributes?(attributes)
                    raise # error
                  end
                end
                single_order_detail.update!(attributes)

              when :confirm
                single_order_detail.single_payment.processing!
                single_order_detail.single_payment.completed!

              end
              send("#{checkout_steps[checkout_step_index(params[:state]) + 1]}!")
              self.reload
            end
            true
          rescue
            false
          end
        end

        private

          def payment_attributes_from_params(single_order_detail,attributes)
            payment_params = {}
            payment_params["id"] = single_order_detail.payment.try(:id)
            payment_params["used_point"] = attributes[:used_point]
            payment_params["amount"] = attributes[:total]
            payment_params["user_id"] = single_order_detail.payment.user_id
            return payment_params
          end

          def valid_payment_attributes?(attributes)
            attributes[:payment_attributes][:address_id].present? && attributes[:payment_attributes][:gmo_card_seq_temporary].present?
          end

      end
    end
  end
end
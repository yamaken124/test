class PurchaseOrder < ActiveRecord::Base
  module Checkout
    def self.included(klass)
      klass.class_eval do
        class_attribute :checkout_flow
        class_attribute :checkout_steps

        def item_with_tax
          single_order_detail.item_total + single_order_detail.additional_tax_total
        end

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
          checkout_steps.in
          clude? step.to_s
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

        def update_from_params(params, permitted_params, request_env = {}, current_user)
          @updating_params = params
          # TODO update shipment
          # TODO update adjustment
          begin
            ActiveRecord::Base.transaction do
              attributes = @updating_params[:order] ? @updating_params[:order].permit(permitted_params).delete_if { |k, v| v.nil? } : {}
              case "#{params[:state]}".to_sym
              when :payment
                attributes[:payment_attributes] ||= {}
                attributes[:payment_attributes][:id] = single_order_detail.payment.try(:id)
                # TODO MAX POINT
                raise if attributes[:used_point] && !valid_point?(attributes[:used_point].to_i) # invalid point error
                single_order_detail.update!(attributes)

                payment_attributes = params[:order].require(:payment_attributes).permit(:address_id,:source_id).merge(used_point: attributes[:used_point])
                sales_entry_response = GmoMultiPayment::Transaction.new(current_user).sales_entry(single_order_detail.id,single_order_detail.total)
                payment_attributes[:gmo_access_id] = sales_entry_response[:access_id]
                payment_attributes[:gmo_access_pass] = sales_entry_response[:access_pass]
                single_order_detail.payment.update(payment_attributes)

              when :confirm
                single_bill.single_payment.paid!
              end

              send("#{checkout_steps[checkout_step_index(params[:state]) + 1]}!")
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
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
								single_order_detail.used_point = \
									if params[:order]['use_all_point'].to_b
									 single_order_detail.allowed_max_use_point
									else
										params[:order][:used_point]
									end
                OrderUpdater.new(single_order_detail).update_totals
                single_order_detail.paid_total = single_order_detail.total
                attributes[:payment_attributes] = attributes[:payment_attributes].merge(payment_attributes_from_params(attributes))
                raise_checkout_payment_error(single_order_detail, attributes)
                single_order_detail.update!(attributes)

              when :confirm
                raise_checkout_common_error(single_order_detail)
                SingleLineItem.complete_items(single_order_detail)
                single_order_detail.payment.processing!
                single_order_detail.payment.completed!
              end

              send("#{checkout_steps[checkout_step_index(params[:state]) + 1]}!")
              self.reload
            end
            true
          rescue => e
            params['error_message'] = e.message
            false
          end
        end


        private

          def payment_attributes_from_params(attributes)
            payment_params = {}
            payment_params["id"] = single_order_detail.payment.try(:id)
            payment_params["amount"] = single_order_detail.total
            payment_params["user_id"] = single_order_detail.single_order.purchase_order.user_id
            payment_params["address_id"] = attributes[:address_id]
            payment_params["used_point"] = single_order_detail.used_point
            payment_params
          end

          def has_credit_card_attribtue?(attributes)
            attributes[:payment_attributes][:gmo_card_seq_temporary].present?
          end

          def has_address_attribtue?(attributes)
            attributes[:payment_attributes][:address_id].present?
          end

          def raise_checkout_payment_error(detail, attributes)
            raise 'payment_attributes_error.used_point_over_limit' if attributes[:payment_attributes][:used_point].to_i > Payment::UsedPointLimit
            raise 'payment_attributes_error.address_missing' unless has_address_attribtue?(attributes)
            raise 'payment_attributes_error.credit_card_missing' unless has_credit_card_attribtue?(attributes)
            raise 'payment_attributes_error.invalid_used_point' if attributes[:payment_attributes][:used_point] && !valid_point?(detail.used_point)
            raise 'payment_attributes_error.invalid_used_point' if attributes[:payment_attributes][:used_point] && ( (detail.item_total + detail.additional_tax_total) < detail.used_point )
            raise_checkout_common_error(single_order_detail)
          end

          def raise_checkout_common_error(detail)
            detail.single_line_items.each do |item|
              variant = Variant.find(item.variant_id)
              unless variant.available? && Product.find(variant.product_id).available?
                raise 'item.invalid_item'
              end
            end
          end

      end
    end
  end
end

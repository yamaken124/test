module Merchandise

  extend ActiveSupport::Concern
  included do
    now = Time.now
    scope :valid, lambda{ where('is_invalid_at >= ?',now).where('is_valid_at <= ?', now) }

    def check_valid
      now = Time.now
      if(is_valid_at < now && is_invalid_at > now)
        "merchandise.valid"
      elsif(is_valid_at > now)
        "merchandise.preparing"
      else
        "merchandise.expired"
      end
    end

    def order_price
      if !single_order.blank?
        if !single_order.first.prices.first.nil?
          single_order.first.prices.first.amount
        end
      end
    end

  end

end
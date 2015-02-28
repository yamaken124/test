module TimeValidityChecker

  extend ActiveSupport::Concern
  included do
    now = Time.now
    scope :valid, lambda{ where('is_valid_at <= ?', now).where('is_invalid_at >= ?',now) }

    def valid(now)
      is_valid_at <= now && is_invalid_at >= now
    end
    def expired(now)
      is_invalid_at < now
    end
    def preparing(now)
      is_valid_at > now
    end

    def classify_validity
      now = Time.now
      if valid(now)
        "merchandise.valid"
      elsif preparing(now)
        "merchandise.preparing"
      elsif expired(now)
        "merchandise.expired"
      end
    end

  end

end
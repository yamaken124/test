module TimeValidityChecker

  extend ActiveSupport::Concern
  included do
    now = Time.now
    scope :active, -> { where('is_valid_at <= ?', now).where('is_invalid_at >= ?',now) }
    scope :expired, -> { where('is_invalid_at < ?',now) }
    scope :preparing, -> { where('is_valid_at > ?', now) }
  end

  def active?(now = Time.now)
    is_valid_at < now && is_invalid_at > now
  end

  def expired?(now = Time.now)
    is_invalid_at < now
  end

  def preparing?(now = Time.now)
    is_valid_at > now
  end

  def classify_validity
    now = Time.now
    if active?(now)
      "time_validity.active"
    elsif expired?(now)
      "time_validity.expired"
    elsif preparing?(now)
      "time_validity.preparing"
    end
  end

end
# == Schema Information
#
# Table name: tax_rates
#
#  id            :integer          not null, primary key
#  amount        :decimal(10, )
#  is_valid_at   :datetime
#  is_invalid_at :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class TaxRate < ActiveRecord::Base

  def self.valid
    now = Time.now
    where('is_valid_at <= ?', now).where('is_invalid_at >= ?', now)
  end

  def self.invalid
    where('is_valid_at > :now OR is_invalid_at < :now ', { now: Time.now })
  end

  def valid?
    now = Time.now
    is_valid_at <= now && is_invalid_at >= now
  end

  def invalid?
    !valid?
  end

  def self.rating
    self.first.amount.to_f + 1
  end
end

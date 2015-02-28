# == Schema Information
#
# Table name: products
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  description   :text(65535)
#  is_valid_at   :datetime
#  is_invalid_at :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Product < ActiveRecord::Base
  has_many :variants
  has_many :prices, :through => :variants
  has_many :images, :through => :variants
  paginates_per 5
  validates :name, :is_valid_at, :is_invalid_at, presence: true

  include TimeValidityChecker

  def master_order_price(order_type)
    if !order_type.blank?
      if !(price = order_type.first.prices).blank?
        price.first.amount
      end
    end
  end

  def single_master_price
    Price.where(variant_id: variants.single_order.pluck(:id)).first.try(:amount)
  end

  def subscription_master_price
    Price.where(variant_id: variants.subscription_order.pluck(:id)).first.try(:amount)
  end

end
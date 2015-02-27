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

  include Merchandise

  enum order_type: {single_order: 1, subscription_order: 2}

  def available
    (!prices.blank? && !images.blank?)
  end

  def order_price(type)
    if !(v = variants.where(order_type: type)).blank?
      if !(p = v.first.prices).blank?
        p.first.amount
      end
    end
  end

end
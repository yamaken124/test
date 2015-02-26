# == Schema Information
#
# Table name: variants
#
#  id            :integer          not null, primary key
#  sku           :string(255)
#  product_id    :integer
#  is_valid_at   :datetime
#  is_invalid_at :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Variant < ActiveRecord::Base
  belongs_to :product
  has_many :prices
  has_many :images, :as => :imageable
  has_many :single_line_items

  validates :product_id,
    uniqueness: {
      scope: [:order_type]
    }
  validates :sku, :order_type, :product_id, presence: true
  enum order_type: {single_order: 1, subscription_order: 2}

  def self.valid
    self.where('is_invalid_at > ? AND is_valid_at < ?', Time.now, Time.now)
  end

end

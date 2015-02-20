class Variant < ActiveRecord::Base
  belongs_to :product
  has_many :prices
  has_many :images, :as => :imageable
  validates :sku, :order_type, presence: true

  scope :valid, -> { where( "is_valid_at <= ? AND is_invalid_at >= ?", Date.today, Date.today ) }

  enum order_type: {single_order: 1, subscription_order: 2}
end
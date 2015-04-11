class Variant < ActiveRecord::Base
  belongs_to :product
  has_one :price
  has_many :images, :as => :imageable
  has_many :single_line_items

  include TimeValidityChecker

  enum order_type: {single_order: 1, subscription_order: 2}
  validates :sku, :name, :order_type, :product_id, :is_valid_at, :is_invalid_at, presence: true

  def has_image_and_price?
    (price.present? && images.present?)
  end

# available means variants which have images and price, and are active
  def available?
    return true if ( has_image_and_price? && (self.stock_quantity > 0) && active? )
    false
  end

  def self.available
    variant_id_having_images_and_prices = Image.where(imageable_type: 'Variant').pluck(:imageable_id) & Price.pluck(:variant_id)
    variant_id_with_stock = Variant.where('stock_quantity > ?', 0 ).pluck(:id)
    active_variant_id = Variant.active.ids

    Variant.where(id: (variant_id_having_images_and_prices & variant_id_with_stock & active_variant_id))
  end

  def self.single_variant
    find_by(order_type: Variant.order_types['single_order'])
  end

  def self.subscription_variant
    find_by(order_type: Variant.order_types['subscription_order'])
  end

end

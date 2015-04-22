# == Schema Information
#
# Table name: variants
#
#  id            :integer          not null, primary key
#  sku           :string(255)      default("all"), not null
#  product_id    :integer
#  name          :string(255)
#  order_type    :integer
#  is_valid_at   :datetime
#  is_invalid_at :datetime
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Variant < ActiveRecord::Base
  belongs_to :product
  has_one :price
  has_many :images, :as => :imageable
  has_many :single_line_items
  has_many :variant_image_whereabouts
  has_one :one_click_item

  include TimeValidityChecker

  enum order_type: {single_order: 1, subscription_order: 2}
  validates :product_id,
    uniqueness: {
      scope: [:order_type]
    }
  validates :sku, :name, :order_type, :product_id, :is_valid_at, :is_invalid_at, presence: true

  def has_image_and_price?
    ( price.present? && images.present? && variant_image_whereabouts.top.present? && variant_image_whereabouts.description.present? )
  end

  def available?
    return true if ( has_image_and_price? && (self.stock_quantity > 0) && active? )
    false
  end

  def self.available
    variant_id_having_images_and_prices = Image.where(imageable_type: 'Variant').pluck(:imageable_id) & Price.pluck(:variant_id)
    variant_id_with_stock = Variant.where('stock_quantity > ?', 0 ).active.pluck(:id)

    available_variant_ids = variant_id_having_images_and_prices & variant_id_with_stock

    available_variant_id_with_all_variant_images = \
      available_variant_ids.select { |id| ( VariantImageWhereabout.where(variant_id: id).top.present? && VariantImageWhereabout.where(variant_id: id).description.present? ) }

    return Variant.none if VariantImageWhereabout.where(variant_id: available_variant_ids).blank?
    Variant.where(id: available_variant_id_with_all_variant_images)
  end

  def self.single_variant
    find_by(order_type: Variant.order_types['single_order'])
  end

  def self.subscription_variant
    find_by(order_type: Variant.order_types['subscription_order'])
  end

  def top_image
    images.where(id: VariantImageWhereabout.where(variant_id: id).pluck(:image_id)).order("position ASC").first.image.url
  end

end

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
  has_one :price
  has_many :images, :as => :imageable
  has_many :single_line_items

  include TimeValidityChecker

  enum order_type: {single_order: 1, subscription_order: 2}
  validates :product_id,
    uniqueness: {
      scope: [:order_type]
    }
  validates :sku, :name, :order_type, :product_id, :is_valid_at, :is_invalid_at, presence: true

  def variant_available?
    (price.present? && images.present?)
  end

  def self.valid_variants
    return @valid_variants if @valid_variants.present?
    variant_id_having_images_and_prices = Image.where(imageable_type: 'Variant').pluck(:imageable_id) & Price.pluck(:variant_id)
    active_variant_id = Variant.active.pluck(:id)

    @valid_variants = Variant.where(id: (variant_id_having_images_and_prices & active_variant_id))
  end

end

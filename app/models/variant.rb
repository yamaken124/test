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
  has_one :upper_used_point_limit

  accepts_nested_attributes_for :upper_used_point_limit
  accepts_nested_attributes_for :price

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
    return Variant.none if VariantImageWhereabout.where(variant_id: Variant.available_ids).blank?

    available_variant_id_with_all_variant_images = \
      Variant.available_ids.select { |id| ( VariantImageWhereabout.where(variant_id: id).top.present? && VariantImageWhereabout.where(variant_id: id).description.present? ) }
    Variant.where(id: available_variant_id_with_all_variant_images).active(Time.now)
  end

  def self.available_ids
    variant_id_having_images_and_prices = Image.where(imageable_type: 'Variant').pluck(:imageable_id) & Price.pluck(:variant_id)
    # 現時点では在庫がなくても”売り切れ”として一覧には表示する
    # variant_id_with_stock = Variant.where('stock_quantity > ?', 0 ).active.pluck(:id)

    variant_id_having_images_and_prices# & variant_id_with_stock
  end

  def self.single_variant
    find_by(order_type: Variant.order_types['single_order'])
  end

  def self.subscription_variant
    find_by(order_type: Variant.order_types['subscription_order'])
  end

  def valid_point?(point, user, quantity)
    (point >= 0) && (point <= max_used_point(user, quantity))
  end

  def max_used_point(user, quantity)
    [user.max_used_point, (upper_used_point * quantity.to_i)].min
  end

  def upper_used_point
    UpperUsedPointLimit.find_by(variant_id: id).limit.to_i
  end

  def top_image
    images.where(id: VariantImageWhereabout.top.where(variant_id: id).pluck(:image_id)).order("position ASC").first.try(:image).try(:url)
  end

  def update_stock_quantity(changed_quantity)
    self.stock_quantity += changed_quantity
    save!
  end

  def belongs_to_one_click_shippment_taxons?
    Taxon::OneClickShippmentIds.include?(product.taxons.ids.first)
  end

end

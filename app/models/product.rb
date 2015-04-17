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
  has_many :products_taxons
  has_many :taxons, :through => :products_taxons
  has_one :product_description
  has_many :how_to_use_products
  has_many :prices, :through => :variants
  has_many :images, :through => :variants
  paginates_per 5
  validates :name, :is_valid_at, :is_invalid_at, presence: true
  accepts_nested_attributes_for :products_taxons
  accepts_nested_attributes_for :product_description
  accepts_nested_attributes_for :how_to_use_products


  include TimeValidityChecker

  AvailableQuantity = 12

  def available?
    active? && ( variants.any? {|v| v.available?} )
  end

  def displayed?(user)
    user.shown_product_ids.any? {|product_id| product_id == id} if user.shown_product_ids.present?
  end

  def self.available
    available_variants = Variant.available.active
    Product.active.where(id: available_variants.pluck(:product_id)) if available_variants.present?
  end

  def preview_images
    single_order = variants.single_order
    subscription_order = variants.subscription_order
    if single_order.present? && single_order.first.available?
      images.where(imageable_id: single_order.ids.first).where(imageable_type: "Variant")
    else
      images.where(imageable_id: subscription_order.ids.first).where(imageable_type: "Variant")
    end
  end

  def single_price
    single_variants = variants.single_order
    Price.where(id: single_variants.ids).index_by(&:variant_id)
  end

  def self.having_images_and_variants
    available_variant_id = Image.where(imageable_type: 'Variant').pluck(:imageable_id) & Price.pluck(:variant_id)
    available_product_id = Variant.active.where(id: available_variant_id).pluck(:product_id).uniq

    Product.where(id: available_product_id)
  end

end

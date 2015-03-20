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
  has_many :prices, :through => :variants
  has_many :images, :through => :variants
  has_many :taxons, :through => :products_taxons
  has_one :products_taxon
  paginates_per 5
  validates :name, :is_valid_at, :is_invalid_at, presence: true
  accepts_nested_attributes_for :products_taxons

  include TimeValidityChecker

  def product_available
    (prices.present? && images.present?)
  end

  def preview_images
    Image.where(imageable_id: variants.single_order.pluck(:id)).where(imageable_type: "Variant")
  end

  def available_quantity
    12
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

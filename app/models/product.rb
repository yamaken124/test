class Product < ActiveRecord::Base
  has_many :variants
  has_many :products_taxons
  has_many :taxons, :through => :products_taxons
  has_one :product_description
  has_many :how_to_use_products
  has_many :once_purchase_product_histories
  has_many :prices, :through => :variants
  has_many :images, :through => :variants
  paginates_per 5
  validates :name, presence: true
  accepts_nested_attributes_for :products_taxons
  accepts_nested_attributes_for :product_description
  accepts_nested_attributes_for :how_to_use_products

  include TimeValidityChecker

  AvailableQuantity = 12

  def available?
    variants.any? {|v| v.available?}
  end

  def displayed?(user)
    user.shown_product_ids.any? {|product_id| product_id == id} if user.shown_product_ids.present?
  end

  def self.available
    available_variants = Variant.available
    Product.where(id: available_variants.pluck(:product_id)) if available_variants.present?
  end

  def preview_images(whereabout) #single only
    imageable_ids = variants.single_order.ids
    images.where(imageable_id: imageable_ids)
      .where( id: VariantImageWhereabout.where(whereabout: VariantImageWhereabout.whereabouts[whereabout.to_sym])
      .where(variant_id: imageable_ids).pluck(:image_id) ).order('position ASC')
  end

  def self.having_images_and_variants
    available_variant_id = Image.where(imageable_type: 'Variant').pluck(:imageable_id) & Price.pluck(:variant_id)
    available_product_id = Variant.active(Time.now).where(id: available_variant_id).pluck(:product_id).uniq

    Product.where(id: available_product_id)
  end

  def one_click_product?
    ProductsTaxon.where(product_id: id).all? {|products_taxon| Taxon::OneClickTaxonIds.include?(products_taxon.taxon_id)}
  end

  def send_to_office?
    Taxon::SendToOfficeTaxonIds.include?(ProductsTaxon.find_by(product_id: id).taxon_id)
  end

  def only_once_purhcase?
    Taxon::OncePurchaseTaxonIds.include?(ProductsTaxon.find_by(product_id: id).taxon_id)
  end

end

# == Schema Information
#
# Table name: products_taxons
#
#  id         :integer          not null, primary key
#  product_id :integer
#  taxon_id   :integer
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ProductsTaxon < ActiveRecord::Base
  belongs_to :product
  belongs_to :taxon

  validates :product_id,
    uniqueness: {
      message: "カテゴリーが重複しています",
      scope: [:taxon_id]
    }

  extend PrivateClassMethod

  def self.products_taxons_attributes(params)
    products_taxons_attributes = { products_taxons_attributes: {} }
    filter_attributes(params, products_taxons_attributes)
  end

  def self.create_products_taxon(product_id, taxon_id)
    if taxon_id.present? && product_id.present?
      ProductsTaxon.new(product_id: product_id, taxon_id: taxon_id).save!
    end
  end

  private_class_method

    def self.filter_attributes(params, products_taxons_attributes)
      params[:product][:products_taxons_attributes].size.times { |i|
        products_taxons_params = params[:product][:products_taxons_attributes].require(i.to_s).permit(:taxon_id, :id)
        if products_taxons_params[:taxon_id].blank?
          destroyed_products_taxon = ProductsTaxon.find(params[:product][:products_taxons_attributes][i.to_s][:id])
          destroyed_products_taxon.destroy! if destroyed_products_taxon.present?
        else
          products_taxons_attributes[:products_taxons_attributes][i.to_s] = products_taxons_params
        end
      }
      products_taxons_attributes
    end

end

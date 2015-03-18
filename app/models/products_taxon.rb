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

  def self.set_products_taxons_attributes(params)
    products_taxons_attributes = {}
    products_taxons_attributes[:products_taxons_attributes] = {}

    products_taxons_attributes = delete_invalid_attributes(params, products_taxons_attributes)
  end

  def self.delete_invalid_attributes(params, products_taxons_attributes)
    cnt = 0
    0.upto(params[:product][:products_taxons_attributes].size-1){|i|
      products_taxons_params = params[:product][:products_taxons_attributes].require(i.to_s).permit(:taxon_id, :id)
      if products_taxons_params[:taxon_id].blank?
        delete_products_taxon(params,i)
      else
        products_taxons_attributes[:products_taxons_attributes][cnt.to_s] = products_taxons_params
        cnt += 1
      end
    }
    products_taxons_attributes
  end

  def self.delete_products_taxon(params,i)
    @abc = ProductsTaxon.find(params[:product][:products_taxons_attributes][i.to_s][:id])
    @abc.destroy!
  end

  def self.create_new_products_taxon(params)
    if params[:new_taxon_id].present?
      ProductsTaxon.new(product_id: params[:id], taxon_id: params[:new_taxon_id]).save!
    end
  end

  def self.without_products_taxon?(params)
    params[:product][:products_taxons_attributes]["0"][:taxon_id].blank?
  end

end

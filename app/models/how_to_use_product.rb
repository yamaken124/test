class HowToUseProduct < ActiveRecord::Base

  belongs_to :product
  validates :description, presence: true

  extend PrivateClassMethod

  def self.attributes_for_product(params)
    attributes = { how_to_use_products_attributes: {} }
    filter_attributes(params, attributes)
  end

  private_class_method

    def self.filter_attributes(params, attributes)
      params[:product][:how_to_use_products_attributes].size.times { |i|
        attributes[:how_to_use_products_attributes][i.to_s] = params[:product][:how_to_use_products_attributes].require(i.to_s).permit(:description)
        attributes[:how_to_use_products_attributes][i.to_s][:position] = i + 1
        attributes[:how_to_use_products_attributes][i.to_s] = attributes[:how_to_use_products_attributes][i.to_s].merge(params[:product][:how_to_use_products_attributes].require(i.to_s).permit(:id)) if (params[:action] == "update")
      }
      attributes
    end

end

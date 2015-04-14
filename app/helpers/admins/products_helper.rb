module Admins::ProductsHelper

  def judge_displayed_product(product, displayed_products)
      return "表示中" if displayed_products.pluck(:id).include?(product.id) 
  end
  
end

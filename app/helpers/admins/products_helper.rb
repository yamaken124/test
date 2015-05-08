module Admins::ProductsHelper

  def judge_displayed_product(product, displayed_products)
      return "公開" if displayed_products.ids.include?(product.id)
  end

end

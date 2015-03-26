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

require 'rails_helper'

RSpec.describe Variant, :type => :model do

  before do
    @product = create(:product)
  end

  describe "TimeValidityChecker" do

    it_behaves_like "is true when true" do
      let(:merchandise) { create(:variant, product_id: @product.id) }
      let(:expired_merchandise) { create(:expired_variant, product_id: @product.id) }
      let(:preparing_merchandise) { create(:preparing_variant, product_id: @product.id) }
    end

  end

end

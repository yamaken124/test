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

  context 'valid single variant' do
    before do
      @product = create(:product)
      @single_variant = create(:single_variant, product_id: @product.id)
    end

    context 'with price' do
      before { create(:price, variant_id: @single_variant.id) }
      it 'has_image_and_price should be false' do
        expect(@single_variant.has_image_and_price?).to eq false
      end
      it 'is not available' do
        expect(@single_variant.available?).to eq false
      end

      context 'with only top image' do
        before do
          @image = Image.create(:image=> File.open(File.join(Rails.root, '/spec/fixtures/sample.png')), imageable_id: @single_variant.id, imageable_type: "Variant" )
          create(:variant_image_whereabout, image_id: @image.id, variant_id: @single_variant.id, whereabout: 1)
        end
        it 'has_image_and_price should be false' do
          expect(@single_variant.has_image_and_price?).to eq false
        end
        it 'is not available' do
          expect(@single_variant.available?).to eq false
        end
        it 'is not shown on top products(self.available)' do
          expect(Variant.available).to eq []
        end

        context 'with top and description image' do
          before { create(:variant_image_whereabout, image_id: @image.id, variant_id: @single_variant.id, whereabout: 2) }
          it 'has_image_and_price should be false' do
            expect(@single_variant.has_image_and_price?).to eq true
          end
          it 'is not available' do
            expect(@single_variant.available?).to eq true
          end
          it 'is shown on top products(self.available)' do
            expect(Variant.available).to eq [Variant.find(@single_variant.id)]
          end

          context 'without stock' do
            before { @single_variant.update(stock_quantity: 0) }
            it 'is not available' do
              expect(@single_variant.available?).to eq false
            end
            it 'is shown on top products(self.available)' do
              expect(Variant.available).to eq [Variant.find(@single_variant.id)]
            end
          end
          context 'not active' do
            before { @single_variant.update(is_valid_at: '2100-01-01') }
            it 'is not available' do
              expect(@single_variant.available?).to eq false
            end
            it 'is not shown on top products(self.available)' do
              expect(Variant.available).to eq []
            end
          end
        end
      end
    end
  end
end

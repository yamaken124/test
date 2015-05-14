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

require 'rails_helper'

RSpec.describe Product, :type => :model do

  context 'with valid single variant' do
    before do
      @user = create(:user)
      @product = create(:product)
      @single_variant = create(:single_variant, product_id: @product.id)
      @price = create(:price, variant_id: @single_variant.id)
      @image = Image.create(:image=> File.open(File.join(Rails.root, '/spec/fixtures/sample.png')), imageable_id: @single_variant.id, imageable_type: "Variant" )
      allow_any_instance_of(User).to receive(:shown_product_ids) {[@product.id]}
    end

    context 'with price' do

      context 'with only top image' do
        before do
          create(:variant_image_whereabout, image_id: @image.id, variant_id: @single_variant.id, whereabout: 1)
        end
        it 'has top preview_images' do
          expect(@product.preview_images('top')).to eq [@image]
        end
        it 'does not have description preview_images' do
          expect(@product.preview_images('description')).to eq []
        end
        it 'is not available' do
          expect(@product.available?).to eq false
        end
        it 'is displayed' do
          expect(@product.displayed?(@user)).to eq true
        end
        it 'has image and variant' do
          expect(Product.having_images_and_variants).to eq [@product]
        end
        it 'is not in available products' do
          expect(Product.available).to eq nil
        end

        context 'with top and description image' do
          before do
            create(:variant_image_whereabout, image_id: @image.id, variant_id: @single_variant.id, whereabout: 2)
          end
          it 'has description preview_images' do
            expect(@product.preview_images('description')).to eq [@image]
          end
          it 'is available' do
            expect(@product.available?).to eq true
          end
          it 'is in available products' do
            expect(Product.available).to eq [@product]
          end
        end
      end
    end
  end

end

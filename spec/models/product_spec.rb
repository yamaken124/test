require 'rails_helper'

RSpec.describe Product, :type => :model do

  describe 'product validations' do

    let(:product) { create(:product) }
    let(:variant) { create(:variant, product_id: product.id ) }
    let!(:image) { Image.create(:image=> File.open(File.join(Rails.root, '/spec/fixtures/sample.png')), imageable_id: variant.id, imageable_type: "Variant" ) }
    let!(:price) { create(:price, variant_id: variant.id ) }

    it 'product_available' do
      expect(product.product_available).to eq true
    end

    it 'having_images_and_variants' do
      expect(Product.having_images_and_variants).to eq [product]
    end

  end

  describe 'prices of each order' do

    context 'single_order_type' do
      let(:product) {create(:product)}
      let!(:single_variant) {create(:single_variant, product_id: product.id)}
      let!(:single_price) {create(:price, variant_id: single_variant.id )}
      let!(:image) { Image.create(:image=> File.open(File.join(Rails.root, '/spec/fixtures/sample.png')), imageable_id: single_variant.id, imageable_type: "Variant" ) }

      it 'expects single_master_price' do
        expect(product.single_master_price).to eq single_price.amount
      end

      it 'preview_images' do
        expect(product.preview_images).to eq [image]
      end

    end

    context 'subscription_order_type' do
      it 'expects subscription_master_price' do
        product = create(:product)
        subscription_variant = create(:subscription_variant, product_id: product.id)
        subscription_price = create(:price, variant_id: subscription_variant.id )
        expect(product.subscription_master_price).to eq subscription_price.amount
      end
    end

  end

end

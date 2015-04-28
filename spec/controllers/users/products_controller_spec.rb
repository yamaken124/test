require 'rails_helper'

RSpec.describe Users::ProductsController, type: :controller do

  before do
    @user = create(:user)
    user_sign_in @user #ここでcategoryつくるのでは？
    @user_category_id = 1
    @taxon_id = 1
  end

  describe '#index, #show, #describe' do
    shared_examples_for 'cannot find products/product' do
      describe 'GET #index' do
        before { get :index }
        it { expect(response).to render_template :index }
        it { expect(assigns(:products)).to eq [] }
      end
      describe 'GET #show' do
        before { get :show, id: @product.id }
        it { expect(assigns(:product)).to eq @product }
        it { expect(response).to redirect_to products_path }
      end
    end

    context 'active' do
      before do
        @product = create(:product)
        create(:users_user_category, user_id: @user.id, user_category_id: @user_category_id)
        create(:user_categories_taxon, user_category_id: @user_category_id, taxon_id: @taxon_id)
        create(:products_taxon, product_id: @product.id, taxon_id: @taxon_id)
        @variant = create(:variant, product_id: @product.id)
      end
      context 'without price' do
        before do
          @image = Image.create(:image=> File.open(File.join(Rails.root, '/spec/fixtures/sample.png')), imageable_id: @variant.id, imageable_type: "Variant" )
          create(:variant_image_whereabout, image_id: @image.id, variant_id: @variant.id)
          create(:variant_image_whereabout, image_id: @image.id, variant_id: @variant.id, whereabout: 2)
        end
        it_behaves_like 'cannot find products/product'
      end

      context 'without image' do
        before { @price = create(:price, variant_id: @variant.id) }
        it_behaves_like 'cannot find products/product'
      end

      context 'with one kind images' do
        before do
          @image = Image.create(:image=> File.open(File.join(Rails.root, '/spec/fixtures/sample.png')), imageable_id: @variant.id, imageable_type: "Variant" )
          @price = create(:price, variant_id: @variant.id)
        end
        context 'with only top images' do
          before { create(:variant_image_whereabout, image_id: @image.id, variant_id: @variant.id) }
          it_behaves_like 'cannot find products/product'
        end
        context 'with only description images' do
          before { create(:variant_image_whereabout, image_id: @image.id, variant_id: @variant.id, whereabout: 2) }
          it_behaves_like 'cannot find products/product'
        end
      end

      context 'with_images_and_price' do
        before do
          @image = Image.create(:image=> File.open(File.join(Rails.root, '/spec/fixtures/sample.png')), imageable_id: @variant.id, imageable_type: "Variant" )
          @price = create(:price, variant_id: @variant.id)
          create(:variant_image_whereabout, image_id: @image.id, variant_id: @variant.id)
          create(:variant_image_whereabout, image_id: @image.id, variant_id: @variant.id, whereabout: 2)
        end
        describe 'GET #index' do
          before { get :index }
          it { expect(response).to render_template :index }
          it { expect(assigns(:products)).to eq [@product] }
        end
        describe 'GET #show' do
          before { get :show, id: @product.id }
          it { expect(assigns(:product)).to eq @product }
          it { expect(response).to render_template :show }
        end
        describe 'GET description' do
          before { get :description, id: @product.id }
          it { expect(assigns(:product)).to eq @product }
          it { expect(response).to render_template :description }
        end
      end

    end

    context 'inactive or invalid product/variant' do

      shared_examples_for 'cannot find products/product even with images and price' do
        before do
          @image = Image.create(:image=> File.open(File.join(Rails.root, '/spec/fixtures/sample.png')), imageable_id: @variant.id, imageable_type: "Variant" )
          @price = create(:price, variant_id: @variant.id)
          create(:users_user_category, user_id: @user.id, user_category_id: @user_category_id)
          create(:user_categories_taxon, user_category_id: @user_category_id, taxon_id: @taxon_id)
          create(:products_taxon, product_id: @product.id, taxon_id: @taxon_id)
          create(:variant_image_whereabout, image_id: @image.id, variant_id: @variant.id)
          create(:variant_image_whereabout, image_id: @image.id, variant_id: @variant.id, whereabout: 2)
        end
        describe 'GET #index' do
          before { get :index }
          it { expect(response).to render_template :index }
          it { expect(assigns(:products)).to eq [] }
        end
        describe 'GET #show' do
          before { get :show, id: @product.id }
          it { expect(assigns(:product)).to eq @product }
          it { expect(response).to redirect_to products_path }
        end
      end

      context 'invalid product' do
        describe 'expired product' do
          before do
            @product = create(:expired_product)
            @variant = create(:variant, product_id: @product.id)
          end
          it_behaves_like 'cannot find products/product even with images and price'
        end
        describe 'preparing product' do
          before do
            @product = create(:preparing_product)
            @variant = create(:variant, product_id: @product.id)
          end
          it_behaves_like 'cannot find products/product even with images and price'
        end
      end

      context 'invalid variant' do
        describe 'expired variant' do
          before do
            @product = create(:product)
            @variant = create(:expired_variant, product_id: @product.id)
          end
          it_behaves_like 'cannot find products/product even with images and price'
        end
        describe 'preparing variant' do
          before do
            @product = create(:product)
            @variant = create(:preparing_variant, product_id: @product.id)
          end
          it_behaves_like 'cannot find products/product even with images and price'
        end
        describe 'variant without stock' do
          before do
            @product = create(:product)
            @variant = create(:variant, product_id: @product.id, stock_quantity: 0)
          end
            it_behaves_like 'cannot find products/product even with images and price'
        end
      end
    end

  end

end

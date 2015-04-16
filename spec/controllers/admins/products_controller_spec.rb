require 'rails_helper'

RSpec.describe Admins::ProductsController, type: :controller do
  before do
    admin_sign_in create(:admin)
  end

  describe 'GET #index' do
    let(:product) { create(:product) }
    before { get :index }

    it { expect(response).to render_template :index }
    it 'assings products' do
      expect(assigns(:products)).to eq [product]
    end
  end

  describe 'POST #create' do
    let(:product) { create(:product) }
    let(:products_taxon) { create(:products_taxon, product_id: product.id) }
    let(:product_description) { create(:product_description, product_id: product.id) }
    let(:how_to_use_product) { create(:how_to_use_product, product_id: product.id) }
    let(:params) do
      {
        id: product.id,
        product: attributes_for(
          :product,
          name: "updated_name",
          products_taxons_attributes: { "0" => {taxon_id: products_taxon.id} },
          product_descriptions: { "0" => {id: product_description.id} },
          how_to_use_products_attributes:{ "0" => {description: how_to_use_product.description} },
        )
      }
    end
    before { post :create, params }

    it 'redirect to varinants#index' do
      expect(response).to redirect_to admins_product_variants_path(product_id: assigns(:product).id)
    end
  end

  describe 'PATCH #update' do
    let(:product) { create(:product) }
    let(:products_taxon) { create(:products_taxon, product_id: product.id) }
    let(:product_description) { create(:product_description, product_id: product.id) }
    let(:how_to_use_product) { create(:how_to_use_product, product_id: product.id) }
    let(:params) do
      {
        id: product.id,
        product: attributes_for(
          :product,
          name: "updated_name",
          products_taxons_attributes: { "0" => {taxon_id: products_taxon.id} },
          product_descriptions: { "0" => {id: product_description.id} },
          how_to_use_products_attributes:{ "0" => {description: how_to_use_product.description} },
        )
      }
    end
    before { patch :update, params }

    it 'update' do
      expect{ patch :update, params; product.reload }.to change(product, :name).to('updated_name')
    end

    it 'redirects to edit_path' do
      # expect(response).to redirect_to admins_product_path(id: assigns(:product).id)
    end
  end

  describe 'GET #new' do
    before { get :new }

    it { expect(response).to render_template :new }
    it 'assigns new one' do
      expect(assigns(:product)).to be_new_record
    end
  end

  describe 'GET #edit' do
    let(:product) { create(:product) }
    before { get :edit, id: product.id }

    it 'assigns product' do
      expect(assigns(:product)).to eq product
    end
    it { expect(response).to render_template :edit }
  end


  describe 'DELETE #destroy' do

    before do
      @product = create(:product)
      @variant = create(:variant, product_id: @product.id)
      delete :destroy, id: @product.id, product: attributes_for(:product)
    end

      it 'update product' do
        @product.reload
        expect(@product.is_invalid_at).to be < Time.now
      end

      it 'respond to product-update and update variant' do
        @variant.reload
        expect(@variant.is_invalid_at).to be < Time.now
      end

      it 'redirects to edit_path' do
        expect(response).to redirect_to admins_products_path
      end
  end

end

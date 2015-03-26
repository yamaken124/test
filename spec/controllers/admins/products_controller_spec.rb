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
    let(:params) do
      {
        product: attributes_for(:product, name: "updated_name", products_taxons_attributes: { "0" => {taxon_id: products_taxon.id} })
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
    let(:params) do
      {
        id: product.id,
        product: attributes_for(:product, name: "updated_name", products_taxons_attributes: { "0" => {id: products_taxon.id, taxon_id: products_taxon.id} }),
        new_taxon_id: ''
      }
    end
    before { patch :update, params }

    it 'assigns product' do
      expect(assigns(:product)).to eq product
    end

    it 'update' do
      expect{ patch :update, params; product.reload }.to change(product, :name).to('updated_name')
    end

    it 'redirects to edit_path' do
      expect(response).to redirect_to admins_product_path(id: assigns(:product).id)
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

    before{ 
      @product = create(:product)
      @variant = create(:variant, product_id: @product.id)
      delete :destroy, id: @product.id, product: attributes_for(:product) }

      it 'update' do
        @product.reload
        expect(@product.is_invalid_at).to be < Time.now
      end

      it 'update' do
        @variant.reload
        expect(@variant.is_invalid_at).to be < Time.now
      end

      it 'redirects to edit_path' do
        expect(response).to redirect_to admins_products_path
      end
  end

end

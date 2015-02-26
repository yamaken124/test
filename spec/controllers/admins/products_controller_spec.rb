require 'rails_helper'

RSpec.describe Admins::ProductsController, type: :controller do

  describe 'GET #index' do
    let(:product) { create(:product) }
    before { get :index }

    it { expect(response).to render_template :index }
    it 'assings products' do
      expect(assigns(:products)).to eq [product]
    end
  end

  describe 'POST #create' do
    let(:params) { { product: attributes_for(:product) } }

    it { expect { post :create, params }.to change(Product, :count).by(1) }
    it do
      post :create, params
      expect(response).to redirect_to edit_admins_product_path(id: assigns(:product).id)
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

  describe 'PATCH #update' do
    let(:product) { create(:product) }
    let(:params) do
      {
        id: product.id,
        product: attributes_for(:product, name: "updated_name")
      }
    end
    before { patch :update, params }

    it 'assigns fincrew' do
      expect(assigns(:product)).to eq product
    end

    it 'update' do
      expect{ patch :update, params; product.reload }.to change(product, :name).to('updated_name')
    end

    it 'redirects to edit_path' do
      expect(response).to redirect_to edit_admins_product_path(id: assigns(:product).id)
    end
  end

  describe 'DELETE #destroy' do
    let(:product) { create(:product) }
    let(:params) do
      {
        id: product.id,
        product: attributes_for(:product, is_invalid_at: Time.now-1)
      }
    end
    before { patch :destroy, params }

    it 'update' do
      product.reload
      expect(product.is_invalid_at).to be < Time.now
    end
    it 'redirects to edit_path' do
      expect(response).to redirect_to admins_products_path
    end

  end
end
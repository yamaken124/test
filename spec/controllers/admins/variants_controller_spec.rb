require 'rails_helper'

RSpec.describe Admins::VariantsController, type: :controller do

  before do
    admin_sign_in create(:admin)
    @product = create(:product)
    @variant = create(:variant, product_id: @product.id)
    @unique_product = create(:product)
  end

  describe 'GET #index' do
    before { get :index, product_id: @variant.product_id }

    it { expect(response).to render_template :index }
    it 'assings variant' do
      expect(assigns(:variants)).to eq [@variant]
    end
  end

  describe 'POST #create' do

    context "unique_parameter" do
      let(:unique_variant_params) { { product_id: @unique_product.id,
        variant: attributes_for(:variant,
          price: attributes_for(:price)) } }
      it { expect { post :create, unique_variant_params }.to change(Variant, :count).by(1) }
      it do
        post :create, unique_variant_params
        expect(response).to redirect_to admins_product_variants_path(product_id: @unique_product.id)
      end
    end

    context "ununique_parameter" do
      let(:variant_params) { { product_id: @product.id,
        variant: attributes_for(:variant,
          price: attributes_for(:price)) } }
      it { expect { post :create, variant_params }.to change(Variant, :count).by(0) }
      it do
        post :create, variant_params
        expect(response).to render_template :new
      end
    end

  end

  describe 'GET #new' do
    before { get :new, product_id: @product.id }

    it { expect(response).to render_template :new }
    it 'assigns new one' do
      expect(assigns(:variant)).to be_new_record
    end
  end

  describe 'GET #edit' do
    let(:variant) { create(:variant) }
    before { get :edit, id: @variant.id, product_id: @variant.product_id }

    it 'assigns product' do
      expect(assigns(:variant)).to eq @variant
    end
    it { expect(response).to render_template :edit }
  end

  # describe 'PATCH #update' do
  #   let(:params) { { product_id: @variant.product_id, id: @variant.id, variant: attributes_for(:variant, order_type: "subscription_order", prices: attributes_for(:price), sku: "all") } }
  #   before { patch :update, params }

  #   it 'assigns fincrew' do
  #     expect(assigns(:variant)).to eq @variant
  #   end
  #   it 'update' do
  #     expect{ patch :update, params; @variant.reload }.to change(@variant, :order_type).to('subscription_order')
  #   end
  #   it 'redirects to edit_path' do
  #     expect(response).to redirect_to admins_product_variants_path(product_id: @variant.product_id)
  #   end
  # end

  describe 'DELETE #destroy' do
    let(:params) { { product_id: @variant.product_id, id: @variant.id, variant: attributes_for(:variant, sku: "updated_sku") } }
    before { patch :destroy, params }

    it 'update' do
      @variant.reload
      expect(@variant.is_invalid_at).to be < Time.now
    end
    it 'redirects to edit_path' do
      expect(response).to redirect_to admins_product_variants_path
    end

  end

end

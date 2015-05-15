require 'rails_helper'

RSpec.describe Admins::ProductsController, type: :controller do
  before do
    admin_sign_in create(:admin)
    @user = create(:user)
    @product = create(:product)
    @user_category_id = 1
    @taxon_id = 1
    create(:users_user_category, user_id: @user.id, user_category_id: @user_category_id)
    create(:user_categories_taxon, user_category_id: @user_category_id, taxon_id: @taxon_id)
    create(:products_taxon, product_id: @product.id, taxon_id: @taxon_id)
    @variant = create(:variant, product_id: @product.id)
    @price = create(:price, variant_id: @variant.id)
    @image = Image.create(:image=> File.open(File.join(Rails.root, '/spec/fixtures/sample.png')), imageable_id: @variant.id, imageable_type: "Variant" )
  end

  describe 'GET #index' do
    before { get :index }

    it { expect(response).to render_template :index }
    it 'assings products' do
      expect(assigns(:products)).to eq [@product]
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
          products_taxons_attributes: { "0" => {taxon_id: products_taxon.id} },
          product_descriptions: {description: product_description.description, nutritionist_explanation: product_description.nutritionist_explanation, nutritionist_word: product_description.nutritionist_word },
          how_to_use_products_attributes:{ "0" => {description: how_to_use_product.description} },
        )
      }
    end
    before { post :create, params }

    it 'redirect to varinants#index' do
      expect(response).to redirect_to admins_product_variants_path(product_id: assigns(:product).id)
    end
    it { expect { post :create, params }.to change(Product, :count).by(1) }
    it { expect { post :create, params }.to change(ProductDescription, :count).by(1) }
    it { expect { post :create, params }.to change(HowToUseProduct, :count).by(1) }

  end

  describe 'PATCH #update' do
    let(:product) { create(:product) }
    let(:products_taxon) { create(:products_taxon, product_id: product.id) }
    let(:product_description) { create(:product_description, product_id: product.id) }
    let(:how_to_use_product) { create(:how_to_use_product, product_id: product.id) }
    let(:params) do
      {
        product: {
          name: 'updated_name',
          products_taxons_attributes: { "0" => {id: products_taxon.id, taxon_id: 1} },
          product_descriptions: {description: product_description.description, nutritionist_explanation: product_description.nutritionist_explanation, nutritionist_word: product_description.nutritionist_word },
          how_to_use_products_attributes:{ "0" => {description: how_to_use_product.description} },
        },
        id: product.id,
      }
    end
    before { patch :update, params }

    it 'update' do
      expect{ patch :update, params; product.reload }.to change(product, :name).to('updated_name')
    end

    it 'redirects to admins_product_path' do
      expect(response).to redirect_to admins_product_path(id: assigns(:product))
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

    it 'redirects to edit_path' do
      expect(response).to redirect_to admins_products_path
    end
  end

  describe 'GET #move_position' do
    before do
      create(:product, id: 1, position: 1)
      create(:product, id: 2, position: 2)
      create(:product, id: 3, position: 3)
      create(:product, id: 4, position: 4)
    end
    context 'move_up' do
      let(:move_up_params) { {
        position: "up", product_id: 2
      } }

      it "locates up position of product" do
        before_product_position = Product.find(move_up_params[:product_id]).position
        get :move_position, move_up_params
        expect(assigns(:product).position).to eq (before_product_position - 1)
      end

      it "redirects to admins#index path" do
        get :move_position, move_up_params
        expect(response).to redirect_to admins_products_path
      end
    end

    context 'move_down' do
      let(:move_down_params) { {
        position: "down", product_id: 2
      } }

      it "locates down position of product" do
        before_product_position = Product.find(move_down_params[:product_id]).position
        get :move_position, move_down_params
        expect(assigns(:product).position).to eq (before_product_position + 1)
      end

      it "redirects to admins#index path" do
        get :move_position, move_down_params
        expect(response).to redirect_to admins_products_path
      end
    end
  end
end

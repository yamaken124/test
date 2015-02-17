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
    let(:params) { { product: attributes_for(:product) \
      .merge(variants: attributes_for(:variant)) \
      .merge(prices: attributes_for(:price)) } }

    it { expect { post :create, params }.to change(Product, :count).by(1) }

    it do
      post :create, params
      expect(response).to redirect_to admins_products_path
    end
  end

  describe 'GET #new' do
    before { get :new }
    it { expect(response).to render_template :new }

    it 'assigns new one' do
      expect(assigns(:product)).to be_new_record
    end
  end

end

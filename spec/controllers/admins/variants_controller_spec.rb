require 'rails_helper'

RSpec.describe Admins::VariantsController, type: :controller do

  before do
     @product = create(:product)
  end
  describe 'POST #create' do
    let(:params) { { product_id: @product.id, variant: attributes_for(:variant) } }

    it { expect {post :create, params}.to change(Variant, :count).by(1) }
    it do
      post :create, params
      expect(response).to redirect_to admins_product_path(@product.id)
    end
  end

  describe 'GET #new' do
    before { get :new, product_id: @product.id }
    it { expect(response).to render_template :new }

    it 'assigns new one' do
      expect(assigns(:variant)).to be_new_record
    end
  end

  end
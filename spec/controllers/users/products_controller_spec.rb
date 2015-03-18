require 'rails_helper'

RSpec.describe Users::ProductsController, type: :controller do

  before do
    @user = create(:user)
    user_sign_in @user
    @product = create(:product)
    @variant = create(:variant, product_id: @product.id)
    @price = create(:price, variant_id: @variant.id)
    @image = create(:image, imageable_id: @variant.id)
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
end

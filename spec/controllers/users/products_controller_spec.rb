require 'rails_helper'

RSpec.describe Users::ProductsController, type: :controller do

  before do
    @user = create(:user)
    @product = create(:product)
    @user_category_id = 1
    @taxon_id = 1
    create(:users_user_category, user_id: @user.id, user_category_id: @user_category_id)
    create(:user_categories_taxon, user_category_id: @user_category_id, taxon_id: @taxon_id)
    create(:products_taxon, product_id: @product.id, taxon_id: @taxon_id)
    user_sign_in @user
    @variant = create(:variant, product_id: @product.id)
    @price = create(:price, variant_id: @variant.id)
    @image = create(:image, imageable_id: @variant.id, imageable_type: 'Variant')
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

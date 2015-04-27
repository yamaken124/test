require 'rails_helper'

RSpec.describe Admins::Bills::CreditsController, type: :controller do
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
    @purchase_order = create(:purchase_order, user_id: @user.id)
    @single_order = create(:single_order, purchase_order_id: @purchase_order.id)
    @single_order_detail = create(:single_order_detail, single_order_id: @single_order.id)
    @payment = create(:payment, single_order_detail_id: @single_order_detail.id)
  end

  describe "GET #index" do
    
    before { get :index }

    it { expect(response).to render_template :index }
    it 'assings payments' do
      expect(assigns(:payments)).to eq [@payment]
    end
  end
end

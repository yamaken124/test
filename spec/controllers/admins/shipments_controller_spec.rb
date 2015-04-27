require 'rails_helper'

RSpec.describe Admins::ShipmentsController, type: :controller do

  before do
    admin_sign_in create(:admin)
    @user = create(:user)
    @product = create(:product)
    @variant = create(:variant, product_id: @product.id)
    @address = create(:address, user_id: @user.id)
    @payment = create(:payment, id: 1)
    @single_order_detail = create(:single_order_detail)
    @single_line_item = create(:single_line_item, variant_id: @variant.id, single_order_detail_id: @single_order_detail.id, payment_state: "completed")
    @payment = create(:payment, user_id: @user.id, single_order_detail_id: @single_order_detail.id)
    @shipment = create(:shipment, id:1, single_line_item_id: @single_line_item.id, state: 10)
  end

  describe 'GET #index' do
    before { get :index }

    it { expect(response).to render_template :index }
    it 'assings shipments' do
      expect(assigns(:shipments)).to eq [@shipment]
    end
  end
    
end

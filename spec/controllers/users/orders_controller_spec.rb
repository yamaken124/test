require 'rails_helper'

RSpec.describe Users::OrdersController, type: :controller do

  before do
    @user = create(:user)
    user_sign_in @user
    address = create(:address, user_id: @user.id)
    purchase_order = create(:purchase_order, user_id: @user.id)
    single_order = create(:single_order, purchase_order_id: purchase_order.id)
    @detail = create(:single_order_detail, single_order_id: single_order.id, address_id: address.id)
    @payment = create(:payment, user_id: @user.id, address_id: address.id, single_order_detail_id: @detail.id)
  end

  describe 'GET #index' do
    let(:product) {create(:product)}
    let(:variant) {create(:variant, product_id: product.id)}
    let(:single_line_item) {create(:single_line_item, single_order_detail_id: @detail.id, variant_id: variant.id)}

    it 'render :index' do
      get :index, id: @payment.single_order_detail_id
      expect(response).to render_template :index
    end
    it 'assings details' do
      get :index, id: @payment.single_order_detail_id
      expect(assigns(:details)).to eq [@detail]
    end
    it 'assings variants' do
      get :index, id: single_line_item.variant_id
      expect(assigns(:variants_indexed_by_id)[single_line_item.variant_id]).to eq variant
    end
  end

  describe 'GET #thanks' do
    before do
      @payment.state = 10
      @payment.save
      get :thanks, number: @payment.number
    end

    it 'render #thanks' do
      expect(response).to render_template :thanks
    end
    it 'assigns payment' do
      @payment.reload
      expect(assigns(:payment)).to eq @payment
    end
    #@payment = Payment.where(number: @number).first 
  end

end

require 'rails_helper'

RSpec.describe Users::CheckoutsController, type: :controller do

  before do
    @user = create(:user)
    user_sign_in @user
    @product = create(:product)
    @variant = create(:variant, product_id: @product.id)
    @address = create(:address, user_id: @user.id)
  end

  describe '#edit' do

    context 'invalid' do

      describe 'redirect_to_profile_if_without_any' do
        before { get :edit, state: 'payment'}
        it { expect(response).to redirect_to edit_profile_path(continue: checkout_state_path(state: :payment)) }
      end

      describe 'redirect to cart if current_order is missing' do
        before do
          @profile = create(:profile, user_id: @user.id)
          get :edit, state: 'payment'
        end
        it { expect(response).to redirect_to cart_path }
      end

      describe 'set state if present' do
        # before do
        #   stub_request(:post, "#{GmoMultiPayment::Domain}/payment/SearchCard.idPass").to_return(status: 200, body: { wellness_mileage: 3 }.to_json)

        #   @profile = create(:profile, user_id: @user.id)
        #   @order = create(:purchase_order, user_id: @user.id, state: 10)
        #   single_order = create(:single_order, purchase_order_id: @order.id)
        #   @detail = create(:single_order_detail, single_order_id: single_order.id, address_id: @address.id)
        #   get :edit, state: 'payment'
        # end
        # it { expect(response).to redirect_to cart_path }
      end
      # before do
      #   @current_order = create(:purchase_order, user_id: @user.id, state: 10)
      #   single_order = create(:single_order, purchase_order_id: @current_order.id)
      #   @detail = create(:single_order_detail, single_order_id: single_order.id, address_id: @address.id)
      #   @single_line_items = create(:single_line_item, variant_id: @variant.id, single_order_detail_id: @detail.id)
      # end

    end

  end


end

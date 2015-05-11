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

      describe 'redirect to cart if detail.item_total is zero' do
        before do
          @profile = create(:profile, user_id: @user.id)
          @order = create(:purchase_order, user_id: @user.id, state: 10)
          single_order = create(:single_order, purchase_order_id: @order.id)
          @detail = create(:single_order_detail, item_total: 0)
          get :edit, state: 'payment'
        end
        it { expect(response).to redirect_to cart_path }
      end
    end
    context 'valid' do
      describe 'render_template edit with cart' do
        before do
          stub_request(:post, "#{GmoMultiPayment::Domain}/payment/SearchCard.idPass").to_return(body: "CardSeq=0&DefaultFlag=0&CardName=&CardNo=*************111&Expire=1903&HolderName=g&DeleteFlag=0")
          @profile = create(:profile, user_id: @user.id)
          @order = create(:purchase_order, user_id: @user.id, state: 10)
          single_order = create(:single_order, purchase_order_id: @order.id)
          @detail = create(:single_order_detail, single_order_id: single_order.id, address_id: @address.id)
          get :edit, state: 'payment'
        end
        it { expect(response).to render_template :edit }
      end
    end
  end

  describe '#update' do
    before do
      stub_request(:post, "#{GmoMultiPayment::Domain}/payment/SearchCard.idPass").to_return(body: "CardSeq=0&DefaultFlag=0&CardName=&CardNo=*************111&Expire=1903&HolderName=g&DeleteFlag=0")
      @profile = create(:profile, user_id: @user.id)
      @order = create(:purchase_order, user_id: @user.id, state: 10)
      single_order = create(:single_order, purchase_order_id: @order.id)
      @detail = create(:single_order_detail, single_order_id: single_order.id, address_id: @address.id)
    end
    context 'valid' do
      let(:params) do
        {
          order: {
            address_id: @address.id,
            payment_attributes: {
              payment_method_id: 1,
              gmo_card_seq_temporary: 0,
            },
            use_all_point: 'false',
            used_point: 0,
          },
          state: 'payment',
        }
      end
      before { patch :update, params }
      it { expect(response).to redirect_to checkout_state_path(state: 'confirm') }
    end
    context 'invalid' do
      context 'render edit in case address is missng' do
        let(:params) do
          { order: {
              address_id: nil, use_all_point: 'false', used_point: 0,
              payment_attributes: { payment_method_id: 1, gmo_card_seq_temporary: 0, },
            }, state: 'payment',
          }
        end
        before { patch :update, params }
        it { expect(response).to render_template :edit }
      end
      context 'render edit with used point over limit' do
        let(:params) do
          { order: {
              address_id: @address.id, use_all_point: 'false', used_point: 10000,
              payment_attributes: { payment_method_id: 1, gmo_card_seq_temporary: 0, },
            }, state: 'payment',
          }
        end
        before { patch :update, params }
        it { expect(response).to render_template :edit }
      end
      context 'render edit in credit card is not found' do
        let(:params) do
          { order: {
              address_id: nil, use_all_point: 'false', used_point: 0,
              payment_attributes: { payment_method_id: 1, gmo_card_seq_temporary: nil, },
            }, state: 'payment',
          }
        end
        before { patch :update, params }
        it { expect(response).to render_template :edit }
      end
      context 'invalid used_point' do

      end
    end
  end


end

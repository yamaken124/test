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
      @profile = create(:profile, user_id: @user.id)
      @image = Image.create(:image=> File.open(File.join(Rails.root, '/spec/fixtures/sample.png')), imageable_id: @variant.id, imageable_type: "Variant" )
      @price = create(:price, variant_id: @variant.id)
      create(:users_user_category, user_id: @user.id, user_category_id: @user_category_id)
      create(:user_categories_taxon, user_category_id: @user_category_id, taxon_id: @taxon_id)
      create(:products_taxon, product_id: @product.id, taxon_id: @taxon_id)
      create(:variant_image_whereabout, image_id: @image.id, variant_id: @variant.id)
      create(:variant_image_whereabout, image_id: @image.id, variant_id: @variant.id, whereabout: 2)
    end
    describe 'from payment to confirm' do
      before do
        stub_request(:post, "#{GmoMultiPayment::Domain}/payment/SearchCard.idPass").to_return(body: "CardSeq=0&DefaultFlag=0&CardName=&CardNo=*************111&Expire=1903&HolderName=g&DeleteFlag=0")
        @order = create(:purchase_order, user_id: @user.id, state: 10)
        single_order = create(:single_order, purchase_order_id: @order.id)
        @detail = create(:single_order_detail, single_order_id: single_order.id, address_id: @address.id)
      end
      context 'without mile' do
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
        describe 'redirect_to confirm' do
          before { patch :update, params }
          it { expect(response).to redirect_to checkout_state_path(state: 'confirm') }
        end
        context 'invalid product' do
          describe 'order should fail and redirect_to cart' do
            before do
              @variant.update(is_valid_at: '2050-01-01')
              create(:single_line_item, variant_id: @variant.id, single_order_detail_id: @detail.id, quantity: 1, price: 100)
              create(:upper_used_point_limit, variant_id: @variant.id, limit:100)
              patch :update, params
            end
            it { expect(response).to redirect_to cart_path }
            it { expect(assigns(:order).state).to eq "fail" }
          end
        end
      end
      context 'with mile' do
        before do
          create(:upper_used_point_limit, variant_id: @variant.id, limit: 1000)
          @single_line_items = create(:single_line_item, variant_id: @variant.id, single_order_detail_id: @detail.id, quantity: 1, price: 100)
          allow_any_instance_of(User).to receive(:wellness_mileage) {100}
          create(:upper_used_point_limit, variant_id: @variant.id, limit:100)
        end
        let(:params) do
          { order: {
              address_id: @address.id, use_all_point: 'false', used_point: 50,
              payment_attributes: { payment_method_id: 1, gmo_card_seq_temporary: 0, },
            }, state: 'payment',
          }
        end
        before { patch :update, params }
        it { expect(response).to redirect_to checkout_state_path('confirm') }
      end
      context 'invalid' do
        context 'address missng' do
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
        context 'used point over limit' do
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
        context 'credit card not found' do
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
          before do
            create(:upper_used_point_limit, variant_id: @variant.id, limit:200)
            @single_line_items = create(:single_line_item, variant_id: @variant.id, single_order_detail_id: @detail.id, quantity: 1, price: 100)
          end
          context 'minus used_point' do
            let(:params) do
              { order: {
                  address_id: @address.id, use_all_point: 'false', used_point: -10,
                  payment_attributes: { payment_method_id: 1, gmo_card_seq_temporary: 0, },
                }, state: 'payment',
              }
            end
            before { patch :update, params }
            it { expect(response).to render_template :edit }
          end
          context 'used_point over wellness_mileage' do
            before do
              allow_any_instance_of(User).to receive(:wellness_mileage) {10}
            end
            let(:params) do
              { order: {
                  address_id: @address.id, use_all_point: 'false', used_point: 50,
                  payment_attributes: { payment_method_id: 1, gmo_card_seq_temporary: 0, },
                }, state: 'payment',
              }
            end
            before { patch :update, params }
            it { expect(response).to render_template :edit }
          end
          context 'used_point over upper_used_point_limit' do
            before do
              allow_any_instance_of(User).to receive(:wellness_mileage) {100}
            end
            let(:params) do
              { order: {
                  address_id: @address.id, use_all_point: 'false', used_point: 300,
                  payment_attributes: { payment_method_id: 1, gmo_card_seq_temporary: 0, },
                }, state: 'payment',
              }
            end
            before { patch :update, params }
            it { expect(response).to render_template :edit }
          end
        end
      end
    end
    describe 'from confirm to thanks' do
      before do
        stub_request(:post, "#{GmoMultiPayment::Domain}/payment/EntryTran.idPass").to_return(body: "AccessID=17002e083c3e908fc0da4770126058ef&AccessPass=e0eef343854a99c2f95c417a9df8d134")
        stub_request(:post, "#{GmoMultiPayment::Domain}/payment/ExecTran.idPass").to_return(body: 'true')
        create(:upper_used_point_limit, variant_id: @variant.id, limit: 1000)
        @order = create(:purchase_order, user_id: @user.id, state: 20)
        @single_order = create(:single_order, purchase_order_id: @order.id)
      end
      let(:params) { {state: 'confirm'} }
      context 'without mile' do
        before do
          allow_any_instance_of(User).to receive(:wellness_mileage) {10000}
          @detail = create(:single_order_detail, single_order_id: @single_order.id, address_id: @address.id, used_point: 0)
          @single_line_items = create(:single_line_item, variant_id: @variant.id, single_order_detail_id: @detail.id, quantity: 1, price: 100)
          @payment = create(:payment, single_order_detail_id: @detail.id, address_id: @address.id, user_id: @user.id, used_point:0)
        end
        describe 'redirect_to thanks page' do
          before { patch :update, params }
          it { expect(response).to redirect_to thanks_orders_path(number: @payment.number) }
        end
        it 'create shipment' do
          expect { patch :update, params }.to change(Shipment, :count).by(1)
        end
        it 'does not create user point history' do
        expect { patch :update, params }.to change(UserPointHistory, :count).by(0)
        end
      end
      context 'with mile' do
        before do
          allow_any_instance_of(User).to receive(:wellness_mileage) {10000}
          @detail = create(:single_order_detail, single_order_id: @single_order.id, address_id: @address.id, used_point: 30)
          @single_line_items = create(:single_line_item, variant_id: @variant.id, single_order_detail_id: @detail.id, quantity: 1, price: 100)
          @payment = create(:payment, single_order_detail_id: @detail.id, address_id: @address.id, user_id: @user.id, used_point: 30)
        end
        describe 'redirect_to thanks page' do
          before { patch :update, params }
          it { expect(response).to redirect_to thanks_orders_path(number: @payment.number) }
        end
        it 'create user point history' do
          expect { patch :update, params }.to change(UserPointHistory, :count).by(1)
        end
      end

      context 'invalid' do
        let(:params) { {state: 'confirm'} }
        before do
          @detail = create(:single_order_detail, single_order_id: @single_order.id, address_id: @address.id, used_point: 30)
          @single_line_items = create(:single_line_item, variant_id: @variant.id, single_order_detail_id: @detail.id, quantity: 1, price: 100)
        end
        context 'payment already completed' do
          before do
            allow_any_instance_of(User).to receive(:wellness_mileage) {10000}
            @payment = create(:payment, single_order_detail_id: @detail.id, address_id: @address.id, user_id: @user.id, state:10)
            patch :update, params
          end
          it { expect(response).to render_template :edit }
        end
        describe 'cannot update wellness_mileage to minus' do
          before do
            allow_any_instance_of(User).to receive(:wellness_mileage) {0}
            @payment = create(:payment, single_order_detail_id: @detail.id, address_id: @address.id, user_id: @user.id, used_point:100)
            patch :update, params
          end
          it { expect(response).to render_template :edit }
        end
      end
    end
  end

end

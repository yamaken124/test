require 'rails_helper'

RSpec.describe PurchaseOrder::Transition, type: :model do
  describe 'states' do
    it do
      expected_states = { "cart" => 0, "payment" => 10, "confirm" => 20, "complete" => 30, "fail" => 40 }
      expect(PurchaseOrder.states).to eq expected_states
    end

    describe 'instance.state' do
      let(:order) { build(:purchase_order) }
      it 'assigns the initial state to cart' do
        expect(order.state).to eq "cart"
        expect(order.cart?).to be_truthy
      end

      let(:cart) { build(:purchase_order, state: 'cart') }
      it { expect(cart.may_cart?).to be_falsy }
      it { expect(cart.may_payment?).to be_truthy }
      it { expect(cart.may_confirm?).to be_falsy }
      it { expect(cart.may_complete?).to be_falsy }

      let(:payment) { build(:purchase_order, state: 'payment') }
      it { expect(payment.may_cart?).to be_truthy }
      it { expect(payment.may_payment?).to be_falsy }
      it { expect(payment.may_confirm?).to be_truthy }
      it { expect(payment.may_complete?).to be_falsy }

      let(:confirm) { build(:purchase_order, state: 'confirm') }
      it { expect(confirm.may_cart?).to be_truthy }
      it { expect(confirm.may_payment?).to be_truthy }
      it { expect(confirm.may_confirm?).to be_falsy }
      it { expect(confirm.may_complete?).to be_truthy }

      context 'moved from confirmed order to completed one' do
        it 'updates main address' do
          user = create(:user)
          address = create(:address, is_main: false, user_id: user.id)
          old_main_address = create(:address, is_main: true, user_id: user.id)
          confirmed_order = create(:purchase_order, state: 'confirm', user_id: user.id)
          confirmed_order.build_single_order.save
          confirmed_order.single_order.build_single_order_detail(address_id: address.id).save

          expect {
            confirmed_order.complete!
            address.reload
            old_main_address.reload
          }.to change(address, :is_main).from(false).to(true)
          expect(old_main_address.is_main).to be_falsy
        end
      end

      let(:complete) { build(:purchase_order, state: 'complete') }
      it { expect(complete.may_cart?).to be_falsy }
      it { expect(complete.may_payment?).to be_falsy }
      it { expect(complete.may_confirm?).to be_falsy }
      it { expect(complete.may_complete?).to be_falsy }
    end
  end
end

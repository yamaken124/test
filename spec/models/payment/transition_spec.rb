require 'rails_helper'

RSpec.describe Payment::Transition, type: :model do
  describe 'states' do
    it do
      expected_states = { 'checkout' => 0, 'completed' => 10, 'processing' => 20, 'pending' => 30, 'failed' => 40, 'canceled' => 50 }
      expect(Payment.states).to eq expected_states
    end

    describe 'instance.state' do
      let(:payment) { build(:payment) }
      it 'assigns the initial state to checkout' do
        expect(payment.state).to eq "checkout"
        expect(payment.checkout?).to be_truthy
      end

      let(:checkout) { build(:payment, state: 'checkout') }
      it { expect(checkout.may_completed?).to be_falsy}
      it { expect(checkout.may_processing?).to be_truthy }
      it { expect(checkout.may_pending?).to be_falsy }
      it { expect(checkout.may_failed?).to be_falsy }
      it { expect(checkout.may_canceled?).to be_falsy }

      let(:completed) { build(:payment, state: 'completed') }
      it { expect(completed.may_completed?).to be_falsy }
      it { expect(completed.may_processing?).to be_falsy }
      it { expect(completed.may_pending?).to be_falsy }
      it { expect(completed.may_failed?).to be_falsy }
      it { expect(completed.may_canceled?).to be_truthy }

      let(:processing) { build(:payment, state: 'processing') }
      it { expect(processing.may_completed?).to be_truthy }
      it { expect(processing.may_processing?).to be_falsy }
      it { expect(processing.may_pending?).to be_truthy }
      it { expect(processing.may_failed?).to be_falsy }
      it { expect(processing.may_canceled?).to be_falsy }

      let(:pending) { build(:payment, state: 'pending') }
      it { expect(pending.may_completed?).to be_truthy }
      it { expect(pending.may_processing?).to be_falsy }
      it { expect(pending.may_pending?).to be_falsy }
      it { expect(pending.may_failed?).to be_truthy }
      it { expect(pending.may_canceled?).to be_falsy }

      let(:failed) { build(:payment, state: 'failed') }
      it { expect(failed.may_completed?).to be_falsy }
      it { expect(failed.may_processing?).to be_falsy }
      it { expect(failed.may_pending?).to be_falsy }
      it { expect(failed.may_failed?).to be_falsy }
      it { expect(failed.may_canceled?).to be_falsy }

      let(:canceled) { build(:payment, state: 'canceled') }
      it { expect(canceled.may_completed?).to be_falsy }
      it { expect(canceled.may_processing?).to be_falsy }
      it { expect(canceled.may_pending?).to be_falsy }
      it { expect(canceled.may_failed?).to be_falsy }
      it { expect(canceled.may_canceled?).to be_falsey }
    end
  end
end

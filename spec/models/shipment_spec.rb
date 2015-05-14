# == Schema Information
#
# Table name: shipments
#
#  id         :integer          not null, primary key
#  payment_id :integer
#  address_id :integer
#  tracking   :string(255)
#  shipped_at :datetime
#  state      :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Shipment, type: :model do
  describe 'states' do
    it do
      expected_states = { 'pending' => 0, 'ready' => 10, 'shipped' => 20, 'canceled' => 30, 'returned' => 40, 'exported' => 50 }
      expect(Shipment.states).to eq expected_states
    end

    describe 'instance.state' do
      let(:shipment) { build(:shipment) }
      it 'assigns the initial state to pending' do
        expect(shipment.state).to eq "pending"
        expect(shipment.pending?).to be_truthy
      end

      let(:pending) { build(:shipment, state: 'pending') }
      it { expect(pending.may_pending?).to be_falsy}
      it { expect(pending.may_ready?).to be_truthy }
      it { expect(pending.may_shipped?).to be_falsy }
      it { expect(pending.may_canceled?).to be_truthy }
      it { expect(pending.may_returned?).to be_falsy }
      it { expect(pending.may_exported?).to be_truthy }

      let(:ready) { build(:shipment, state: 'ready') }
      it { expect(ready.may_pending?).to be_truthy }
      it { expect(ready.may_ready?).to be_falsy }
      it { expect(ready.may_shipped?).to be_falsy }
      it { expect(ready.may_canceled?).to be_truthy }
      it { expect(ready.may_returned?).to be_falsy }
      it { expect(ready.may_exported?).to be_truthy }

      let(:exported) { build(:shipment, state: 'exported') }
      it { expect(exported.may_pending?).to be_falsy }
      it { expect(exported.may_ready?).to be_falsy }
      it { expect(exported.may_shipped?).to be_truthy }
      it { expect(exported.may_canceled?).to be_falsy }
      it { expect(exported.may_returned?).to be_falsy }
      it { expect(exported.may_exported?).to be_falsy }

      let(:shipped) { build(:shipment, state: 'shipped') }
      it { expect(shipped.may_pending?).to be_falsy }
      it { expect(shipped.may_ready?).to be_falsy }
      it { expect(shipped.may_shipped?).to be_falsy }
      it { expect(shipped.may_canceled?).to be_falsy }
      it { expect(shipped.may_returned?).to be_truthy }
      it { expect(shipped.may_exported?).to be_falsy }

      let(:canceled) { build(:shipment, state: 'canceled') }
      it { expect(canceled.may_pending?).to be_falsy }
      it { expect(canceled.may_ready?).to be_falsy }
      it { expect(canceled.may_shipped?).to be_falsy }
      it { expect(canceled.may_canceled?).to be_falsy }
      it { expect(canceled.may_returned?).to be_falsy }
      it { expect(canceled.may_exported?).to be_falsy }

      let(:returned) { build(:shipment, state: 'returned') }
      it { expect(returned.may_pending?).to be_falsy }
      it { expect(returned.may_ready?).to be_falsy }
      it { expect(returned.may_shipped?).to be_falsy }
      it { expect(returned.may_canceled?).to be_falsy }
      it { expect(returned.may_returned?).to be_falsy }
      it { expect(returned.may_exported?).to be_falsy }
    end
  end
end
